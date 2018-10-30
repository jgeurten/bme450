function plotCircle(c, r, lw)

th = (0:pi/50:2*pi)';
x_c = r*cos(th)+c(1);
y_c = r*sin(th)+c(2);
hold on
plot(x_c,y_c,'LineWidth', lw);