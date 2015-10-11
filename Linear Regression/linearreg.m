function linearreg(x,y,delta_y)

w=1./((delta_y).^2);
x_mean=sum(w.*x)/sum(w);
y_mean=sum((w.*y))/(sum(w));
D=sum(w.*((x-x_mean).^2));
m=(1/D)*(sum(w.*(x-x_mean).*y));
c=y_mean-m*x_mean;
n=length(x);
d=y-m*x-c;
delta_m=sqrt((1/D)*(sum(w.*(d.^2)))/(n-2));
delta_c=sqrt((1/(sum(w))+((x_mean^2)/D))*((sum(w.*(d.^2)))/(n-2)));

plot_title=input('Enter plot title: ','s');
x_axis_title=input('Enter x-axis title: ','s');
y_axis_title=input('Enter y-axis title: ','s');

x_min=input('Enter x-axis minimum value: ');
x_max=input('Enter x-axis maximum value: ');
y_min=input('Enter y-axis minimum value: ');
y_max=input('Enter y-axis maximum value: ');

figure
hold on;

title(plot_title);
xlabel(x_axis_title);
ylabel(y_axis_title);

hold on;
title(plot_title);
xlabel(x_axis_title);
ylabel(y_axis_title);
hold on;
plot(x,y,'k.');
errorbar(x,y,delta_y, 'k.');
axis([x_min x_max y_min y_max]);
a=(x_min):0.01:(x_max);
b=m*a+c;
strm = num2str(m);
stry = 'y = ';
strx = 'x + ';
strc = num2str(c);
strz = 'delta m =';
strk = 'delta c =';
strdelta_m = num2str(delta_m);
strdelta_c = num2str(delta_c);
strt = strcat(stry,strm,strx,strc);
stru = strcat(strz,strdelta_m);
strv = strcat(strk,strdelta_c);
plot(a,b,'k-');
legend(stru,strv,strt);

