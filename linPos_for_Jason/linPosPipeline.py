import pandas as pd
import numpy as np
# import matplotlib.pyplot as plt
# import seaborn as sns
import scipy.io
import networkx as nx
import plot_linear_distance as pld
import loren_frank_data_processing as lfdp
import sys
import logging
import matlab.engine


def getPositionFromTrodesFile(posFile):
	#this function will call readTrodesExtractedDataFile.m and return the data struct as a 
	#pandas df containing the two LED coordinates and head Angle (0 being x axis).
	#Also returns midpoints of LED at each timestep.
	eng.rTEDFPyth(posFile, nargout = 0)
	pos, posLabel, midPoint = eng.retrievePositionPy2('data.mat', nargout = 3)

	posData = {}
	for i in range(len(posLabel)):
	    posData[posLabel[i]] = np.asarray(pos[i])
	pos_df = pd.DataFrame.from_dict(posData)
	
	#(x2,y2) is front LED
	pos_df['headAngle'] = pd.Series(np.arctan((posData['y2'] - posData['y1'])/(posData['x2'] - posData['x1'])))

	return pos_df, np.asarray(midPoint)


def createTrackGraph(tree_task):
	#recieves track coordinates as array, and returns a networkx graph of the track
	linearcoord = tree_task['linearcoord'].squeeze()

	track_segments = [np.stack((arm[:-1], arm[1:]), axis=1) for arm in linearcoord]
	center_well_position = track_segments[0][0][0]
	track_segments, center_well_position = (np.unique(np.concatenate(track_segments), axis=0),
	            center_well_position)

	nodes = np.unique(track_segments.reshape((-1, 2)), axis=0)

	edges = np.zeros(track_segments.shape[:2], dtype=int)
	for node_id, node in enumerate(nodes):
	    edge_ind = np.nonzero(np.isin(track_segments, node).sum(axis=2) > 1)
	    edges[edge_ind] = node_id

	edge_distances = np.linalg.norm(
	    np.diff(track_segments, axis=-2).squeeze(), axis=1)

	track_graph = nx.Graph()

	for node_id, node_position in enumerate(nodes):
	    track_graph.add_node(node_id, pos=tuple(node_position))

	for edge, distance in zip(edges, edge_distances):
	    track_graph.add_edge(edge[0], edge[1], distance=distance)

	center_well_id = np.unique(
	    np.nonzero(np.isin(nodes, center_well_position).sum(axis=1) > 1)[0])[0]

	return track_graph, track_segments, center_well_id


if __name__ == "__main__":
	#First argument is track graph .mat file
	#Second argument is the path to the position .dat file
	#third argument is desired name of binned data numpy array

	args = sys.argv[1:]
	logging.basicConfig(level=logging.INFO)
	eng = matlab.engine.start_matlab()
	print(args)


	tree_task = scipy.io.loadmat(args[0])
	pos_df, position = getPositionFromTrodesFile(args[1])

	track_graph, track_segments, center_well_id = createTrackGraph(tree_task)

	###Track segment classification from position
	track_segment_id = lfdp.track_segment_classification.classify_track_segments(
    	track_graph, position,
    	sensor_std_dev=10, route_euclidean_distance_scaling=1)

	###Calculating linear distance from back well
	linear_distance = lfdp.track_segment_classification.calculate_linear_distance(
        track_graph, track_segment_id, center_well_id, position)


	#Convert pixel to cm
	linear_distance_cm = linear_distance / 4.37


	###Smooth track segment identification and bin position based on track segment
	track_smooth = pld.smooth_track_segs(track_segment_id)
	linear_bin = pld.bin_position(linear_distance_cm, track_smooth)

	pos_df['track_seg'] = pd.Series(track_smooth)
	pos_df['lin_pos'] = pd.Series(linear_bin)
	
	pld.plot_linear_distance(linear_distance_cm, linear_bin, position, (72000,73000))
	np.save(args[2],linear_bin)

	eng.quit()














