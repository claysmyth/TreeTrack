import numpy as np
import pandas as pd

import networkx as nx

from position import make_track_graph
from track_segment_classification import plot_track

epoch_key = ('bon', 3, 1)
animals = {'bon': ('data', 'bon')}
track_graph = make_track_graph(epoch_key, animals)
plot_track(track_graph)

