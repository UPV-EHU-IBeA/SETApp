function [LarvaSize] = UrchinSize(sample)
%% Dist 590 = 1000um

sizetemp = imread(sample);
sizetemp = imrotate(sizetemp,90);
[y1,x1] = find(sizetemp < 255,1,'first');
[y2,x2] = find(sizetemp < 255,1,'last');
dist =sqrt((y2-y1)^2+(x2-x1)^2);
LarvaSize = dist*1000/590;


end
