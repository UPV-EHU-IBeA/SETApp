names = UrchinSep();
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
%% Measure 
files1 = dir('*tiff');
for i = 1: length(files1)
[LarvaSize(i)] = UrchinSize(files1(i).name);
end
%%
[MyDataSet] = UrchinParam();
%%
load ClassFirstModel
load ClassSecondModel

%%
X_test = MyDataSet.data;
firstpred = plsdapred(X_test,firstmodel);

secondpred = plsdapred(X_test,secondmodel);

P=[firstpred.class_pred secondpred.class_pred];
for i=1:size(P,1)
    if P(i,1) == 2
        class_pred{i}='bad';
    else
        if P(i,2) == 1
            class_pred{i}='good';
        else
            class_pred{i}='intermediate';
        end
    end
end

Level3 = sum(P(:,1) == 2);
Level1 = sum(P(:,1) == 1 & P(:,2) == 1);
Level2 = sum(P(:,1) == 1 & P(:,2) == 2);
Levels = [Level1;Level2;Level3];
axis = categorical({'Level 1','Level 2','level 3'})
bar(axis,Levels); 


