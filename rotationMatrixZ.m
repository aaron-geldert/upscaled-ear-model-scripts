function R = rotationMatrixZ(thetaDegrees)
% ROTATIONMATRIXZ Rotates XY coordinates around the Z axis, in degrees
R =  [cosd(thetaDegrees), -sind(thetaDegrees), 0;...
        sind(thetaDegrees),  cosd(thetaDegrees), 0;...
        0,            0,           1];

end