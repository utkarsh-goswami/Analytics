function acc=getAccuracy(Xlab, desPath, fName,rName, cName, dataset)
if(exist(desPath)==0)
    mkdir(desPath);
else
    'Path Already exists'
end
numFeat=size(Xlab,2)-1;
load(fName);
ranks=f;
lab=Xlab(:,end);
Xlab=Xlab(:,1:end-1);
X1=Xlab(:,ranks);
%For HD data
if(numFeat>60)
    numFeat=60;
end
acc=zeros(1,numFeat);
        for i=1:numFeat
            A=[X1(:,1:i)];
            acc(i)=accuracy(A, lab, cName);
            if(acc(i)==100) 
                break;
            end
        end
for  j=1:numFeat
     fprintf(' %d',acc(j));
end  
%filename='';
filename=fullfile(desPath,strcat(rName, '_', cName, '_rankAcc_', dataset));
save(filename,'acc');
[m, n]=max(acc);
diary results_filter
fprintf('\n%s', rName);
fprintf('\n%s', cName);
fprintf('\n');
fprintf('Max accuracy  %f with %d genes\n',m,n);
for  j=1:n
     fprintf(' %d',ranks(j));
end  
diary off
