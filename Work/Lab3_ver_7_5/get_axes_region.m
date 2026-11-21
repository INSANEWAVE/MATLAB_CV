function rect = getaxesregion

point1 = get(gca,'CurrentPoint');
rbbox;
point2 = get(gca,'CurrentPoint');
p1 = point1(1,1:2);
p2 = point2(1,1:2);

rect = zeros(1,4);
    
rect(1:2) = min(p1,p2);
rect(3:4) = abs(p1-p2);

hold on;
x=[rect(1) rect(3)+rect(1) rect(3)+rect(1) rect(1)         rect(1)];
y=[rect(2) rect(2)         rect(4)+rect(2) rect(4)+rect(2) rect(2)];
plot(x,y,'Color','green');
hold off;

