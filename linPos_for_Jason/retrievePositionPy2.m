function [pos, posLabel, midPoint] = retrievePositionPy2(posData)
%inputs: posdata = position data.mat file from .pos, created in
%   readTrodesExtractedDataFile.m
%outputs: midPoints between red and green LEDs at each trodes sampling point
%         midPoints saved under fileName (e.g 'ratXMidPoints.mat')

posData = load(posData);
posData = posData.data.fields;

midPointX = arrayfun(@(x,y) (x+y)/2, double(posData(2).data), double(posData(4).data));

midPointY = arrayfun(@(x,y) (x+y)/2, double(posData(3).data), double(posData(5).data));

midPoint = [midPointX midPointY];

pos = [posData(2).data'; posData(3).data'; posData(4).data'; posData(5).data'];

posLabel = {'x1', 'y1', 'x2', 'y2'};