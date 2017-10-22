clear
pos=[randn(100,1),randn(100,1)]; 
neg=[randn(100,1)*sqrt(5)+5,randn(100,1)*sqrt(5)]; 
plot(pos(:,1),pos(:,2),'r+',neg(:,1),neg(:,2),'bx'); 
x=[pos;neg];
t=x;
d=[ones(100,1);zeros(100,1)];
test_pos=[randn(100,1),randn(100,1)];
test_neg=[randn(100,1)*sqrt(5)+5,randn(100,1)*sqrt(5)]; 
test=[test_pos;test_neg];
x1 = x(:,1);
test1 = test(:,1);
x2 = x(:,2);
test2 = test(:,2);
[N,junk] = size(x);
r = randperm(N); % chose one row as the center
nCenter = 2; %suppose we have 2 hidden center
r=r(1:nCenter); % represent which 2 rows i choose to become center
t_select=[t(r,:)];% build center 
t_select_test=[t(r,:)];
[m,junk] = size(t_select);
[m_test,junk] = size(t_select_test);
t1 = t_select(:,1);
t2 = t_select(:,2);
t1_test = t_select_test(:,1);
t2_test = t_select_test(:,2);
T1=ones(N,1)*t1';
T2=ones(N,1)*t2';
T1_test=ones(N,1)*t1_test';
T2_test=ones(N,1)*t2_test';
X1= x1*ones(1,m);
TEST1 = test1*ones(1,m_test);
X2=x2*ones(1,m);
TEST2 = test2*ones(1,m_test);
%find out dmax  
dmax = 0;
for i = 1:1:nCenter
    for j = 1:1:nCenter
        temp = sqrt((t_select(i,1)-t_select(j,1)).^2+(t_select(i,2)- t_select(j,2)).^2);
        if temp > dmax
            dmax = temp;
        end
        
    end
end
sigma=dmax/sqrt(2*nCenter)
G = exp(-sqrt((X1-T1).^2 + (X2-T2).^2)*(nCenter/dmax.^2));
G_test = exp(-sqrt((TEST1-T1).^2 + (TEST2-T2).^2)*(nCenter/dmax.^2));
w = inv(G'*G)*G'*d;
output_train = G*w;
output_test = G_test*w;
a1=round(output_train); 
a2=round(output_test);
c_correctness_train=0; c_correctness_test=0;
% caculate accuracy for positive 
for i=1:1:100
    if a1(i,1) == 1
        c_correctness_train=c_correctness_train+1;
    end
    if a2(i,1) == 1
        c_correctness_test=c_correctness_test+1;
    end
end
% caculate accuracy for negative 
for j=101:1:200 
    if a1(j,1) == 0
        c_correctness_train=c_correctness_train+1;
    end
    if a2(j,1) == 0
        c_correctness_test=c_correctness_test+1;
    end
end
accuracy_train = c_correctness_train/200 
accuracy_test = c_correctness_test/200
