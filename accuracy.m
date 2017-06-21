function [r]=accuracy(A, lab, cName)
        x= [A lab];
        [m n]=size(x);
        y=[];
        y=[ x(:,1:n-1) x(:,n)];
        accur=0;
        count=m;
        r=0;
        accur=0;
        cvo=cvpartition(m,'leaveout');
        for j=1:cvo.NumTestSets
            tridx=find(cvo.training(j)>0);
            ytr=[];
            for idx1=1:size(tridx)
                ytr=[ytr; y(tridx(idx1),:)];
            end
           switch(cName)
               case 'svm'
                   w=svmtrain(ytr(:,n), ytr(:,1:n-1),'-c 1  -q');
                   teidx=find(cvo.test(j)>0);
                   yte=[];
                   size(teidx)
                   for idx2=1:size(teidx)
                       yte=[yte; y(teidx(idx2),:)];
                   end
                   [p1 p2 p3]=svmpredict(yte(:,n), yte(:,1:n-1),w);
                   acc = p2(1);
                   accur=accur+acc;                   
               case 'knnc'
                   acc = ClassificationKNN.fit(ytr(:,1:n-1), ytr(:,n));
                   teidx=find(cvo.test(j)>0);
                   yte=[];
                   size(teidx)
                   for idx2=1:size(teidx)
                       yte=[yte; y(teidx(idx2),:)];
                   end
                   cpre=predict(acc,yte(:,1:n-1));
                   if(cpre==yte(:,n))
                       local_accur=100;
                   else
                       local_accur=0;
                   end
                   accur=accur+local_accur;
           end
           r=accur/cvo.NumTestSets;                        
        end        
end    
        