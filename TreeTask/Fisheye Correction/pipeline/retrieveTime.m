function [timestamps] = retrieveTime(dataFile)
%Recieves time stamps from raw position file

data1 = load(dataFile);
data = data1.data.fields;
timestamps = data(1).data;