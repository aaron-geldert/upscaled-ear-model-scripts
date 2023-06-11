%% Visualize Ear Model and Measurement Points
% This example demonstrates the 3D model data of the ear and its 
% coordinate system.
%
% Ref: "Dataset of acoustic intensity vector measurements around an upscaled ear model"
%       Aaron Geldert, Marton Marschall, Ville Pulkki
%       Audio Engineering Society Europe 154th Convention (May 2023)
%       
% Dataset: https://zenodo.org/record/7564880#.ZFu5qS0Rpp8
% Scripts: https://github.com/aaron-geldert/upscaled-ear-model-scripts
% 
% Created by Aaron Geldert with MATLAB R2020b
% Last modified: 8 April 2023


%% Initializations

clear; clc; close all;

% Replace pwd with path to repository parent folder
repo_path = pwd; 
addpath(genpath([repo_path '/model_data']));

load('ear_model.mat');
load('measPos.mat');

% Extract coordinates from measPos
x = measPos(:,1); 
y = measPos(:,2);
z = measPos(:,3);

%% Plot the ear

figure(1);
p1 = patch(ear_model, 'FaceColor', [0.9 0.8 0.7], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);
material('dull');
axis('image');
% camup([0 1 0]);           % sets an XY plane view
view([30 60]);              % sets an angled 3D view
camlight('headlight');
grid off; hold on;  
xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');
title('Ear model measurement points');

%% Plot the coordinates per Z plane

z_uniq = unique(z);
for ii = 1:length(z_uniq)
    plane_inds = z == z_uniq(ii);
    c = 0.8*rescale(z_uniq); % differentiate the planes by color
    h_grid = scatter3(x(plane_inds), y(plane_inds), z(plane_inds), 50,...
        '.','MarkerEdgeColor',[1-c(ii) 0.2 0.2+c(ii)]);
end
