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
sigma=0.04;
deviation= 2* sigma.^2;
phi=[];
for i=1:1:200
    for j=1:1:200
        phi(i,j)=exp(- (1/(2* sigma.^2)) * (sqrt(((x(i,1)-t(j,1)).^2)+((x(i,2)-t(j,2)).^2))).^2);
        phi_test(i,j)=exp(- (1/(2* sigma.^2)) * (sqrt(((test(i,1)-test(j,1)).^2)+((test(i,2)-test(j,2)).^2))).^2);
    end
end
% weight is based on phi(which is the train set)
w=inv(phi)*d; 
output_test=(w'*phi_test)';
output_train=(w' * phi)';
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
% 
% for i=1:1:200
% if(out_test(i)>0.5) 
%     out_test(i)=1;
% else
%     out_test(i)=0;
% end
% end
% error=0;
% for i=1:1:200
% error=error+abs(out_test(i)-d(i));
% end
% error=error/200