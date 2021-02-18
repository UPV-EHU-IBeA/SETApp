function [MyDataSet] = UrchinParam()
files1 = dir('*tiff');
for l = 1:length(files1);
    LarvaSizeBien(l) = UrchinSize(files1(l).name);
    a = imread(files1(l).name);
   
    BW = imbinarize(a);
    [B,L] = bwboundaries(BW,'noholes'); %imshow(label2rgb(L, @jet, [.5 .5 .5]))
    
    a = L < 1;
    
    a = imfill(a,'holes');
    
    a = imerode(a, strel('disk',2));
    a = bwareaopen(a,1000);
    cent = regionprops(a,'Centroid');
    CH = regionprops(a,'ConvexHull');
   maxRows = max(CH.ConvexHull(find(CH.ConvexHull(:,2) > ((max(CH.ConvexHull(:,2))- max(CH.ConvexHull(:,2))/6))),1)); %Buscar la cordenada mas a la derecha Pata derecha
    minRows = min(CH.ConvexHull(find(CH.ConvexHull(:,2) > ((max(CH.ConvexHull(:,2))- max(CH.ConvexHull(:,2))/6))),1));%Buscar la cordenada mas a la izquierda Pata izquierda
    minCol = min(CH.ConvexHull(:,2)); %Buscar la cordenada mas arriba
    [x1,y1] = find(CH.ConvexHull == maxRows);
    x1 = x1(1);
    x1 = x1(1);
    [x2,y2] = find(CH.ConvexHull == minRows);
    x2 = x2(1);
     y2 = y2(1);
    [x3,y3] = find(CH.ConvexHull == minCol);
    x3 = x3(1);
    y3 = y3(1);
    
    [h,w] = size(a);
    
    P0 = [CH.ConvexHull(x3,1),CH.ConvexHull(x3,2)]; %Cordenada esquina superior
    P1 = [CH.ConvexHull(x1,1),CH.ConvexHull(x1,2)]; %Cordenada pata derecha
    P2 = [CH.ConvexHull(x2,1),CH.ConvexHull(x2,2)]; %Cordenada pata izquierda
    n1 = (P2 - P0) / norm(P2 - P0);  % Normalized vectors
    n2 = (P1 - P0) / norm(P1 - P0);
    
    PerpleftBientemp = ((P0(:) + P2(:)) ./ 2)';
    Disttemplefttemp1 = [PerpleftBientemp;cent.Centroid];
    DistPerplefttemp2 = pdist(Disttemplefttemp1,'Euclidean');
    DistPerpleftBien(l) = DistPerplefttemp2;
    PerprightBientemp = ((P0(:) + P1(:)) ./ 2)';
    Disttemprighttemp1 = [PerprightBientemp;cent.Centroid];
    DistPerprighttemp2 = pdist(Disttemprighttemp1,'Euclidean');
    DistPerprightBien(l) = DistPerprighttemp2;
    
    PerpRatioBien(l) = DistPerprighttemp2/DistPerplefttemp2;
    
    %imagesc(a);
    %hold on
    %imshow(CH)
    %plot(CH.ConvexHull(:,1),CH.ConvexHull(:,2),'r');
    %plot(cent.Centroid(1),cent.Centroid(2),'b*'); 
    %plot(w/2,1,'r*');
    %plot(w/2,h,'r*');
   
    %plot(CH.ConvexHull(x1,1),CH.ConvexHull(x1,2),'g*'); %Cordenadas de la esquina inferior derecha del convex hull
   %plot(CH.ConvexHull(x2,1),CH.ConvexHull(x2,2),'g*');
    %plot(CH.ConvexHull(x3,1),CH.ConvexHull(x3,2),'g*');
   % imshow(CH)
   %figure
    %hold off
    
    %Angle of the top corner
    
   
    
    LegHeightRatioBien(l) = abs(CH.ConvexHull(x2,2) - CH.ConvexHull(x1,2));
    if LegHeightRatioBien(l) == 0 ;
        LegHeightRatioBien(l) = LegHeightRatioBien(l) + 1;
    end
    
    AlphaBien(l) = atan2(norm(det([n2; n1])), dot(n1, n2));       
    
    %Distance from centroid to legs adn top
    
    Dist1 = [P1;cent.Centroid];
    Dist2 = [P2;cent.Centroid];
    Dist0 = [P0;cent.Centroid];
    RightLegDistBien(l) = pdist(Dist1,'euclidean');
    LeftLegDistBien(l) = pdist(Dist2,'euclidean');
    TopDistBien(l) = pdist(Dist0,'euclidean');
    LegSizeRatioBien(l) = RightLegDistBien/LeftLegDistBien;
    
    % ConvexHull Area
    
    ConvHullAreaBien(l) = polyarea(CH.ConvexHull(:,1),CH.ConvexHull(:,2));
     
     % Larvae Area/ConvexHull Area
     
     AreaBien(l) = regionprops(a,'Area');
     
     AreaRatioBien (l) = AreaBien(l).Area / ConvHullAreaBien(l);
     
     %Perimeter and Fractal Dimension
     
     PerimeterBien(l) = regionprops(a,'Perimeter');
     
     %Sum of the columns and rows
     
     dh = sum(a)'; %Vertical sum
     dv = sum(a')'; %Left to right sum
  
    b = imerode(a, strel('disk',6));
    % imagesc(b);
  
    sumpix1 = sum(b, 2);
    first = find(sumpix1 > 0, 1, 'first');
    
    topSumBien(l) = sum(sumpix1(first:first+10)); %Puede ayudar a saber si la punta está afilada o abierta con malformación.
    %SumafilaBien(l,:) = sumpix1;
    
    Centroid(l) = regionprops(a,'Centroid');
    n3 = (P2 - Centroid(l).Centroid) / norm(P2 - Centroid(l).Centroid);  % Normalized vectors
    n4 = (P1 - Centroid(l).Centroid) / norm(P1 - Centroid(l).Centroid);
    BetaBien(l) = atan2(norm(det([n4; n3])), dot(n3, n4));   %Angle between centroid and both legs
    
    ConvexHull(l) = regionprops(a,'ConvexHull');
    AreaBien(l) = regionprops(a,'Area');
    CircularityBien(l) = regionprops(a,'Circularity'); 
    EccentricityBien(l) = regionprops(a,'Eccentricity');
    MajorAxisBien(l) = regionprops(a,'MajorAxisLength');
    MinorAxisBien(l) = regionprops(a,'MinorAxisLength');
    
    
end


 for g = 1:length(files1)
     MajorAxis(1,g) = MajorAxisBien(g).MajorAxisLength;
 end
 
  for g = 1:length(files1)
     MinorAxis(1,g) = MinorAxisBien(g).MinorAxisLength;
  end
 MajorMinorAxis = [MajorAxis./MinorAxis];
%

DataParametrizationtemp = [AlphaBien;BetaBien;AreaRatioBien;ConvHullAreaBien;LeftLegDistBien;LegHeightRatioBien;LegSizeRatioBien;PerimeterBien.Perimeter;RightLegDistBien;LarvaSizeBien;DistPerpleftBien;DistPerprightBien;PerpRatioBien;topSumBien;TopDistBien;AreaBien.Area;CircularityBien.Circularity;EccentricityBien.Eccentricity;MajorAxisBien.MajorAxisLength;MinorAxisBien.MinorAxisLength;MajorMinorAxis]';
 VariableNames = {'Alpha';'Beta';'AreaRatio';'ConvHullArea';'LeftLegDist';'LegHeigthRatio';'LegSizeRatio';'Perimeter';'RightLegDist';'Size'; 'PerpleftDist';'PerpRightDist';'PerpRatio';'TopSum';'TopDist';'Area';'Circularity';'Eccentricity';'MajorAxisLength';'MinorAxisLength';'MajorMinorRatio'};
 
 MyDataSet = dataset(DataParametrizationtemp);
 MyDataSet.label{2} = VariableNames;
end
  