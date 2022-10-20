function [BestCost,BestValue,Best]=GMPBSA(fhd,nPop,nVar,VarMin,VarMax,MaxIt,X)
DIM_RATE=1;
for i=1:nPop
    val_X(i) = fhd(X(i,:));
end
historical_X = repmat(VarMin, nPop, 1) + rand(nPop, nVar) .* (repmat(VarMax-VarMin, nPop, 1));
BestCost(1)=min(val_X);
for it=2:MaxIt
    
    if rand<rand
        historical_X=X;
    end
    historical_X=historical_X(randperm(nPop),:);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    map=ones(nPop,nVar);     %%%
    if rand<rand
        for i=1:nPop
            u=randperm(nVar);
            map(i,u(1:ceil(DIM_RATE*rand*nVar)))=0;
        end
    else
        for i=1:nPop
            map(i,randi(nVar))=0;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    F1=3*randn;
    F2=3*randn;
    [~,la]=sort(val_X);
    x1=X(la(1),:);
    x2=X(la(2),:);
    x3=X(la(3),:);
    vmax=max([x1;x2;x3]);%feature zone-I, Eq. (9)
    vmin=min([x1;x2;x3]);%feature zone-I, Eq. (10)
    % Teacher Phase
    x1=X(la(nPop),:);
    x2=X(la(nPop-1),:);
    x3=X(la(nPop-2),:);
    vvmax=max([x1;x2;x3]);%feature zone-II,Eq. (11)
    vvmin=min([x1;x2;x3]);%feature zone-II,Eq. (12)
    MM=mean(X);
    for i=1:nPop
        fi=rand;
        gi=1-fi;
        TP=vmin+rand(1,nVar).*(vmax-vmin);
        TPP=vvmin+rand(1,nVar).*(vvmax-vvmin);
        if fi<=1/3%Eq.(17)
            Xi=X(i,:)+fi*F1.*map(i,:).*(historical_X(i,:)-X(i,:))+gi*F2.*map(i,:).*(historical_X(i,:)-(fi*TP+gi*MM));
        elseif fi>=2/3
            Xi=X(i,:)+fi*F1.*map(i,:).*(historical_X(i,:)-X(i,:))+gi*F2.*map(i,:).*(historical_X(i,:)-(fi*TPP+gi*MM));
        else
            Xi=X(i,:)+fi*F1.*map(i,:).*(historical_X(i,:)-X(i,:))+gi*F2.*map(i,:).*(historical_X(i,:)-MM);
        end
        
        Xi = boundConstraint_absorb(Xi, VarMin, VarMax);
        val_Xi =  fhd(Xi);
        if val_Xi<val_X(i)
            val_X(i) = val_Xi;
            X(i,:) = Xi;
        end
    end
    [~,index_Best] = sort(val_X);
    BestValue=val_X(index_Best(1));
    Best=X(index_Best(1),:);
    BestCost(it)=BestValue;
    %    disp(['Iteration: ',num2str(it),'   Fmin= ',num2str(BestValue,15)]);
end
end