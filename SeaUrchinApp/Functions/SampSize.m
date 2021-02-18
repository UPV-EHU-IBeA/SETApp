function [MeanSize,SampName] = SampSize()
dirinfo = dir();
dirinfo(~[dirinfo.isdir]) = [];  %remove non-directories
subdirinfo = cell(length(dirinfo));
for K = 1 : length(dirinfo);
  thisdir = dirinfo(K).name;
  foldernames{K} = str2cell(thisdir)
  %foldernames{}
  subdirinfo{K} = dir(fullfile(thisdir, '*.tif'));
end
for J = 1: (length(subdirinfo)-2)
subdirinfotemp{J}  = subdirinfo{J+2,1};
%subdirinfo4  = subdirinfo{4,1}
%subdirinfo5  = subdirinfo{5,1}
pathtemp{J} = subdirinfotemp{J}.folder;
end

%
for T = 1: (length(subdirinfo)-2)
folder =  cd (char(pathtemp(T)))
[names,newStr] = SampleSep();
files2 = dir('*tiff'); 

    for i = 1:length(files2)
        a = files2(i).name;
        b{i} = a
    end
        b = b'
        c = setdiff(b,names)

    for i = 1:length(files2)/2
        delete(char(c(i)));
    end
    
files1 = dir('*tiff');
    for i = 1:length(files1)
        [SampleSize(i)] = UrchinSize(files1(i).name);
    end
    MeanSize(T) = mean(SampleSize)
    SampName{T} = newStr
end
end

