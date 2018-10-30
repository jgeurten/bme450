%Lab 2 Script

cur_dir = pwd; 
shot_data = ['Shot Angle', 'ID', 'W_In', 'W_Out', 'Vx_In', 'Vx_Out', 'Vy_In', 'Vy_Out'];
%Get oblique shot data
oblique_dir = [cur_dir, '\shots\oblique_angle\shot']; 
for i=1:5
    path = [oblique_dir, num2str(i), '.wmv']; 
    [w_in, w_out, vx_in, vx_out, vy_in, vy_out] = track_golf_ball(path); 
    shot_data = [shot_data; 'Oblique', i, w_in, w_out, vx_in, vx_out, vy_in, vy_out]; 
end
%Get acute shot data
acute_dir = [cur_dir, '\shots\shallow_angle\shot']; 
for i=1:5
    path = [acute_dir, num2str(i), '.wmv']; 
    [w_in, w_out, vx_in, vx_out, vy_in, vy_out] = track_golf_ball(path); 
    shot_data = [shot_data; 'Acute', i, w_in, w_out, vx_in, vx_out, vy_in, vy_out]; 
end

csvwrite([cur_dir, '\ShotData.csv'], shot_data); 