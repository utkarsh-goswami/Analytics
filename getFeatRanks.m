function filename=getFeatRanks(X,lab,tech,desPath, dataset)
if(exist(desPath)==0)
    mkdir(desPath);
else
    desPath
    'Path already exists'
end
nClasses=numel(unique(lab));
n=size(X,1);
numFeat=size(X,2);

samplePerClass=[];
for i=1:nClasses
    samplePerClass(i)=numel(find(lab==i));
end
[Yi, YTotal, si2]=genYMats(X, lab,numFeat,nClasses, samplePerClass)
numFeat=size(X,2);
F=zeros(1,numFeat);
filename=fullfile(desPath,strcat(tech,'_ranks_', dataset));
j=1;
switch tech
    case 'Ftest'
        for i=1:numFeat
            j=1;
            while(j<=nClasses)
                F(i)=((n-nClasses)*sum(samplePerClass(j)*(Yi(i,:)-YTotal(i)).^2))/((nClasses-1)*sum((samplePerClass(j)-1)*si2(i,:)));
                j=j+1;
            end
        end
                
    case 'Wtest'
        for i=1:numFeat
            j=1;
            while(j<=nClasses)
                W(i,:)=samplePerClass(j)./si2(i,:);
                h(i,:)=W(i,:)./sum(W(i,:));
                f1=sum(h(i,:).*Yi(i,:));
                numerator=W(i,:).*(Yi(i,:)-f1).^2;
                fact=2*(nClasses-2)*inv(nClasses+1);
                denomi=(nClasses-1)+fact*sum(inv(samplePerClass(j)-1)*((1-h(i,:)).^2));
                F(i)=sum(numerator)/denomi;
                j=j+1;
            end
        end
        
    case 'AWtest'
        for i=1:numFeat
            j=1;
            while(j<=nClasses)
                phi=(samplePerClass(j)+2)/(samplePerClass(j)+1);
                wstar(i,:)=samplePerClass(j)./(phi.*si2(i,:));
                hstar(i,:)=wstar(i,:)./sum(wstar(i,:));
                f1=sum(hstar(i,:).*Yi(i,:));
                numerator=wstar(i,:).*(Yi(i,:)-f1).^2;
                fact=2*(nClasses-2)*inv(nClasses+1);
                denomi=(nClasses-1)+fact*sum(inv(samplePerClass(j)-1)*((1-hstar(i,:)).^2));
                F(i)=sum(numerator)/denomi;
                j=j+1;
            end
        end
        
    case 'Ctest'
        for i=1:numFeat
            j=1;
            while(j<=nClasses)
                W(i,:)=samplePerClass(j)./si2(i,:);
                h(i,:)=W(i,:)./sum(W(i,:));
                f1=sum(h(i,:).*Yi(i,:));
                numerator=W(i,:).*(Yi(i,:)-f1).^2;
                F(i)=sum(numerator);
                j=j+1;
            end
        end                     
end
[m f]=sort(F,'descend')
save (filename,'f');
end
        
function [Yi, YTotal, si2]=genYMats(X, lab,numFeat,nClasses, samplePerClass)
Yi=zeros(numFeat, nClasses);
si2=zeros(numFeat,nClasses);
for feat=1:numFeat
    for k = 1:nClasses
        r=find(lab==k);
        Yi(feat,k)=mean(X(r,feat));
        si2(feat,k)=sum((X(r,feat)-Yi(feat,k)).^2)/(samplePerClass(k)-1);
    end
end
YTotal=mean(X);
end

                