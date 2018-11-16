function [c,r] = solve_circular_intersection(center, radius)

syms x y

eqn1 = (x - center(1,1))^2 + (y - center(1,2))^2 - radius(1)^2 == 0; 
eqn2 = (x - center(2,1))^2 + (y - center(2,2))^2 - radius(2)^2 == 0; 

sol = solve([eqn1, eqn2], [x, y]);
int_x = double(sol.x); 
int_y = double(sol.y); 

r = max(abs(int_x(1) - int_x(2)), abs(int_y(1) - int_y(2)));
c = [(int_x(1)+int_x(2))/2, (int_y(1)+int_y(2))/2];



end