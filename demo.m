clc
clear all
lb = -10.*ones(1,10);
ub = 10.*ones(1,10);
maxit = 1000;
objf= @Sphere;
n = 30;
d = 10;
for i=1:n
    X(i,:)=lb+(ub-lb).*rand(1,d);
end
[BestCost,BestValue,Best]=GMPBSA(objf,n,d,lb,ub,maxit,X);
plot(BestCost,'r','linewidth',2)
xlabel('The number of iterations','Fontname','Times New Roma','fontsize',15);
ylabel('Fitness value','Fontname','Times New Roman','fontsize',15);