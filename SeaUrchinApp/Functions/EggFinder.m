function [subsamples] = EggFinder(sample,plots)


a = imread(sample); % Leemos UNA imagen

name = sample;

a = double(a); % Transformamos en double para operar con ella
a = (a - min(a(:)))*255/(max(a(:)) - min(a(:))); % Normalizamos entre 0 y 255 (escala de grises)
m = a < 140; % Threshold que igual tienes que cambiar en alguna imagen
m = imdilate(m,strel('disk',1)); % Truco para unir pixeles
m = imfill(m,'holes'); % rellenamos huecos
m = m - bwareaopen(m, 15000); % Eliminamos puntos menores
m = bwareaopen(m,1000); % Nos quedamos con elementos grandes
m =  imclearborder(m); % Buena esa
%m = imerode(m,strel('disk',7)); % Normalmente hay que deshacer algunos pasos, como el dilate
m = bwareaopen(m,2000); % Por seguridad

c = regionprops(m,'BoundingBox'); % Ahora vemos cuantos elementos tenemos

for i = 1:length(c)
    coord = c(i).BoundingBox;
    if floor(coord(1)) <= 0; coord(1) = 1; end
    if floor(coord(2)) <= 0; coord(2) = 1; end
    anew{i} = a(floor(coord(2)-10):floor(coord(2)+10)+coord(4),floor(coord(1)-10):floor(coord(1))+coord(3)+10);
    
    n{i} = double(anew{i}) < 100;
    n{i} = imdilate(n{i},strel('disk',1));
    n{i} = imfill(n{i},'holes');
    n{i} = bwareaopen(n{i},2000);
    anew{i}(~n{i}) = 255;
end

%

for j = 1:length(anew)
    samplesub = anew{j} + 1; % truco para poder eliminar la parte negra que la rotación te añade después
    mask = n{j};
    samplessub{j} = samplesub;
    cc = regionprops(mask,'Orientation');
    if cc.Orientation >= 0
        newsample = imrotate(samplesub,90 - cc.Orientation);
    else
        newsample = imrotate(samplesub,90 + abs(cc.Orientation)); % Rotamos 90 grados menos el ángulo en orientación
    end
    newsample(newsample == 0) = 256;
    newsample = newsample - 1; % deshaciendo el truco
    o(j,1) = cc.Orientation;
    newsample = uint8(newsample); % Retransformamos en imagen
    subsamples{j} = double(newsample);
    
    mask2{j} = subsamples{j} < 140; % Aqui viene la rotación, atención!
    mask2{j} = bwareaopen(mask2{j},5000); 
    sumpix = sum(mask2{j}, 2);
    first = find(sumpix > 0, 1, 'first');
    last = find(sumpix > 0, 1, 'last');
    topSum = sum(sumpix(first:first+100));
    botSum = sum(sumpix(last-100:last));
   
    if topSum > botSum
  subsamples{j} = imrotate(subsamples{j}, 180);
    end
  %  size{i,j} = regionprops(mask2{j},'MajorAxisLength'); %PROBLEMA AQUI HE INTENTADO CREANDO PRIMERO MATRIZ DE CEROS PERO NADA
    goodsample = subsamples{j};
    goodsample = uint8(goodsample); %Esto no se si era como tenia que hacer para guardarlo, pero funciona
    newname = [name(1:end-4) '_' num2str(j) '.tiff'];
    
    imwrite(goodsample,newname,'tiff');  
end

if plots == 1
    for j = 1:length(subsamples)
        subplot(2,length(subsamples),j); imagesc(samplessub{j}); % Original
        subplot(2,length(subsamples),length(subsamples) + j); imagesc(subsamples{j}); % Rotated
    end
    %colormap gray;
    %figure;
   %imagesc(a); colormap gray;
else
end
