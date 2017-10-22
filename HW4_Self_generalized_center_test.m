clc;
close all;
clear;
pos=[randn(100,1),randn(100,1)]; 
neg=[randn(100,1)*sqrt(5)+5,randn(100,1)*sqrt(5)]; 
x_ori=[pos;neg];
x = x_ori(:,1);
y = x_ori(:,2);
t_raw=x_ori;
d=[ones(100,1);zeros(100,1)];
test_pos=[randn(100,1),randn(100,1)];
test_neg=[randn(100,1)*sqrt(5)+5,randn(100,1)*sqrt(5)]; 
test=[test_pos;test_neg];
test_x = test(:,1);
test_y = test(:,2);
%randomly choose distince tk and input vector 
k=randi([1,200],1,2); % k(1,1) means how many centers k(1,2) means which input is selected
tk_number=randperm(200);%permutation of 1--200 , descide which rows of t_raw are chosen to be center at first
index=sort(tk_number(1:2)); % choose k(1,1) rows to be center at first.
%  use the XOR example. %Four centers t1(0,0)'; t2(1,1)'
% t=[0,0;1,1];
sigma=2;
deviation= 2* sigma.^2 ;
[junk,index_size]=size(index); t=[];
for in=1:1:index_size 
    t(in,:)=t_raw(index(in),:);
end
eta=0.15; %learning rate = 0.15
%similarity matching:find the best-matching center vector tk(x); 
kx=[];
for n=1:1:2000  % set loop 2000 times
    for q=1:1:2 % (x(k(1,2),y(k(1,2)) is the chosen input 
        kx(q)=sqrt((x(k(1,2))-t(q,1)).^2 + (y(k(1,2))-t(q,2)).^2);
    end
[junk,o]=min(kx);
%update center t.
%for i=1:1:k(1,1);
t(o,:)=t(o,:)+eta*(x_ori(k(1,2),:)-t(o,:)); 
%end
k(1,2)=randi([1,4],1,1);  % choose another input
n=n+1;
end
%construct the matrix of G
G=[];
for a=1:1:2  % has 2 centers
for b=1:1:200  % has 200 rows
    G(b,a) = exp(- (1/deviation) *(sqrt((x(b)-t(a,1)).^2+(y(b)-t(a,2)).^2)).^2);
    G_test(b,a)= exp(- (1/deviation) *(sqrt((test_x(b)-t(a,1)).^2+(test_y(b)-t(a,2)).^2)).^2);
end
end
w=inv(G'*G)*G'*d; 
output_train = G*w;
output_test = G_test*w;
a1=round(output_train); a2=round(output_test);
c_accuracy_train=0; c_accuracy_test=0;
for i=1:1:100
    if a1(i,1) == 1
        c_accuracy_train=c_accuracy_train+1;
    end
    if a2(i,1) == 1
        c_accuracy_test=c_accuracy_test+1;
    end
end
j=101;
for j=101:1:200
    if a1(j,1) == 0 
        c_accuracy_train=c_accuracy_train+1;
    end
    if a2(j,1) == 0
        c_accuracy_test=c_accuracy_test+1;
    end
end
accuracy_train = c_accuracy_train/200 
accuracy_test = c_accuracy_test/200
t
