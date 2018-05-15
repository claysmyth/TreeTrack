import numpy as np
import pandas as pd

import networkx as nx
import matplotlib.pyplot as plt

from collections import namedtuple
from .position import make_track_graph
from .track_segment_classification import plot_track, classify_track_segments
from scipy.io import loadmat

epoch_key = ('bon', 3, 1)
Animal = namedtuple('Animal', {'directory', 'short_name'})
ANIMALS = {
    'bon': Animal(directory='loren_frank_data_processing/tree_data',
                  short_name='bon'),
}
track_graph, center_well_id = make_track_graph(epoch_key, ANIMALS)
print(track_graph.nodes(data=True))
print(track_graph.edges(data=True))
plot_track(track_graph)
pos = loadmat('loren_frank_data_processing/tree_data/correctedPos.mat')
correctedPos = pos['correctedPos']
print("pos shape is",correctedPos.shape)
print(correctedPos[100,:])
print('you made it this far...')
segment_id = classify_track_segments(track_graph, correctedPos)
print(np.unique(segment_id))