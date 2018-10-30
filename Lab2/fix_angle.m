function fixedAngle = fix_angle(angle)

% initialize
fixedAngle = angle;

events = find(abs(diff(angle)) > pi);
if numel(events) == 0
    return % angle is continuous
end

for i = 1:numel(events)
   if angle(events(i)+1) > angle(events(i))
       fixedAngle(events(i)+1:end) = fixedAngle(events(i)+1:end) - 2*pi;
   else
       fixedAngle(events(i)+1:end) = fixedAngle(events(i)+1:end) + 2*pi;
   end
end
    