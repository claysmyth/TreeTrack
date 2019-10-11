import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import scipy.io

def test():
    print('test')

def plot_linear_distance(linear_distance_naive, linear_distance2, position, indices):
    time_ind = slice(*indices)
    fig, axes = plt.subplots(1, 2, figsize=(20, 10))
    axes[0].plot(linear_distance_naive[time_ind], linewidth=2, label='naive')
    axes[0].plot(linear_distance2[time_ind], linewidth=2, label='HMM2')
    axes[0].set_xlabel('time')
    axes[0].set_ylabel('distance (cm)')
    axes[0].legend();
    
    axes[1].plot(position[:, 0], position[:, 1])
    axes[1].plot(position[time_ind][:, 0], position[time_ind][:, 1],
                 linewidth=3)
    start_stop = position[time_ind][[0, -1], :]
    axes[1].scatter(start_stop[0, 0], start_stop[0, 1],
                    label='start', color='lightgreen', s=100, zorder=1000)
    axes[1].scatter(start_stop[1, 0], start_stop[1, 1],
                    label='stop', color='red', s=100, zorder=1000)
    axes[1].legend()
    plt.show()


def plot_test(x,y):
    indices = (0,10)
    time_ind = slice(*indices)
    fig, axes = plt.subplots(1, 1, figsize=(20, 10))
    axes[0].plot(x, linewidth=2, label='naive')
    axes[0].plot(y, linewidth=2, label='HMM2')
    axes[0].set_xlabel('time')
    axes[0].set_ylabel('distance (cm)')
    axes[0].legend();
    plt.show()

def get_time_ind(timeA, timeB, segments_df, position):
    interval = (segments_df.iloc[-1]['end_time'] - segments_df.iloc[0]['start_time'])/len(position)
    real_timeA = int((timeA - segments_df.iloc[0]['start_time'])/interval)
    real_timeB = int((timeB - segments_df.iloc[0]['start_time'])/interval)
    return real_timeA, real_timeB

def smooth_track_segs(track_segment_id):
    track_smooth = np.copy(track_segment_id)
    for i in range(1,len(track_segment_id)):
        if (track_segment_id[i] != np.roll(track_segment_id,-1)[i]) & (track_segment_id[i] != np.roll(track_segment_id,1)[i]):
            track_smooth[i] = np.roll(track_segment_id,1)[i]
        if (track_segment_id[i] != np.roll(track_segment_id,-2)[i]) & (track_segment_id[i] != np.roll(track_segment_id,2)[i]):
            track_smooth[i] = np.roll(track_segment_id,2)[i]
    return track_smooth


def bin_position(linear_distance, track_segs):
    linear_bin = np.zeros_like(linear_distance)
    max1 = np.amax(linear_distance[np.where(track_segs == 4)])

    #back well
    linear_bin[np.where(track_segs == 4)] = linear_distance[np.where(track_segs == 4)]

    #left arm
    linear_bin[np.where(track_segs == 2)] = linear_distance[np.where(track_segs == 2)]
    max2 = np.amax(linear_distance[np.where(track_segs == 2)])
    print("max5 is ", max2)

    #straight arm
    linear_bin[np.where(track_segs == 5)] = linear_distance[np.where(track_segs == 5)] - max1 + max2
    max3 = np.amax(linear_bin[np.where(track_segs == 5)])

    #right arm
    linear_bin[np.where(track_segs == 6)] = linear_distance[np.where(track_segs == 6)] - max1 + max3
    max4 = np.amax(linear_bin[np.where(track_segs == 6)])

    #left bottom
    linear_bin[np.where(track_segs == 0)] = linear_distance[np.where(track_segs == 0)] - max2 + max4
    max5 = np.amax(linear_bin[np.where(track_segs == 0)])
    print("max5 is ", max5)

    #left top
    linear_bin[np.where(track_segs == 1)] = linear_distance[np.where(track_segs == 1)] - max2 + max5
    max6 = np.amax(linear_bin[np.where(track_segs == 1)])
    min6 = np.amin(linear_bin[np.where(track_segs == 1)])
    print("max6 is ", max6)
    print("min6 is ", min6)
    print(np.where((track_segs == 1) & (linear_bin == min6)))


    #straight left
    top = np.amax(linear_distance[np.where(track_segs == 5)])
    linear_bin[np.where(track_segs == 3)] = linear_distance[np.where(track_segs == 3)] - top + max6
    max7 = np.amax(linear_bin[np.where(track_segs == 3)])
    min7 = np.amin(linear_bin[np.where(track_segs == 3)])
    print("max7 is ", max7)
    print("min7 is ", min7)


    #straight right
    linear_bin[np.where(track_segs == 7)] = linear_distance[np.where(track_segs == 7)] - top + max7
    max8 = np.amax(linear_bin[np.where(track_segs == 7)])
    print("max8 is ", max8)

    #right top
    right = np.amax(linear_distance[np.where(track_segs == 6)])
    linear_bin[np.where(track_segs == 8)] = linear_distance[np.where(track_segs == 8)] - right + max8
    max9 = np.amax(linear_bin[np.where(track_segs == 8)])
    print("max9 is ",max9)

    #right bottom
    linear_bin[np.where(track_segs == 9)] = linear_distance[np.where(track_segs == 9)] - right + max9
    max10 = np.amax(linear_bin[np.where(track_segs == 9)])
    print("max10 is ",max10)

    return linear_bin