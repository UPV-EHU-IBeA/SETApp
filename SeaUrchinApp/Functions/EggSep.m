function[names] = EggSep()
folder = cd
    
files = dir('*.tif');
for k = 1:length(files);
    try
[subsamples] = EggFinder(files(k).name,1);
    catch
end
close all

end
 








files = dir('*.tiff');

newStr = extractAfter(folder,'\')
npath =  count(newStr,'\')

for i = 1:npath
if contains(newStr,'\')
newStr = extractAfter(newStr,'\')
else
end
end


for i = 1:length(files);
temp = zeros(500, 450); 
a = imread(files(i).name);
[rows columns] = size(a);

if mod(rows,2) ~= 0;
a(rows+1,:) = 255;
else
end

if mod(columns,2) ~= 0;
a(:,columns+1) = 255;
else
end
[rows2 columns2] = size(a);    
    
temp(1:(300-rows)/2) = 0;
temp(((500-rows2)/2:(500-(500-rows2)/2)-1),((450-columns2)/2:(450-(450-columns2)/2)-1)) = a;
anew = temp;
anew(temp == 0) = 255;
anew = uint8(anew);

nametemp = files(i).name;

newname = [newStr '_' num2str(i,'%d') '.tiff'];
names{i,1} = newname
    
    imwrite(anew,newname,'tiff');  
end
end
