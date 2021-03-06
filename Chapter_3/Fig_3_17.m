
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This work is supplementary material for the book                        %
%                                                                         %
% Jens Ahrens, Analytic Methods of Sound Field Synthesis, Springer-Verlag %
% Berlin Heidelberg, 2012, https://doi.org/10.1007/978-3-642-25743-8      %
%                                                                         %
% It has been downloaded from http://soundfieldsynthesis.org and is       %
% licensed under a Creative Commons Attribution-NonCommercial-ShareAlike  % 
% 3.0 Unported License. Please cite the book appropriately if you use     % 
% these materials in your own work.                                       %
%                                                                         %
% (c) 2012, Jens Ahrens                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% both Fig. 3.17(a) and (b) will be created 

y_ref    = 1;
theta_pw = pi/4;
phi_pw   = pi/2;
f        = 1000; % Hz
c        = 343;  % m/s
k        = (2*pi*f)/c;

k_pw_x = k * cos( theta_pw ) * sin( phi_pw );
k_pw_y = k * sin( theta_pw ) * sin( phi_pw );
k_pw_z = k * cos( phi_pw );

% create spatial grid
Y        = linspace( -1, 3, 200 );
Z        = linspace( -2, 2, 200 );
[ y, z ] = meshgrid( Y, Z );
x        = 0;

% Eq.(3.82)
S = exp( -i .* k_pw_y .* y_ref ) ./ besselh( 0, 2, k_pw_y .* y_ref ) .* ...
    exp( -i .* k_pw_x .* x     ) .* besselh( 0, 2, k_pw_y .* sqrt( y.^2 + z.^2 ) );   

% Fig. 3.17(a)
figure;
imagesc( Y, Z, real( S ), [ -2 2 ] );
turn_imagesc;
colormap gray;
axis square;

hold on;
% plot secondary source distribution
plot( 0, 0, 'k.' )
% plot horizontal plane
plot( [ -1 3 ],  [ 0 0 ], 'k:' )
hold off;

xlabel( 'y (m)' );
ylabel( 'z (m)' );
graph_defaults;

% Fig. 3.17(b)
figure;
imagesc( Y, Z, 20*log10 ( abs( S ) ), [ -10 10 ] );
turn_imagesc;
colormap gray;
revert_colormap;
colorbar;
axis square;

hold on;
% plot secondary source distribution
plot( 0, 0, 'k.' )
% plot horizontal plane
plot( [ -1 3 ],  [ 0 0 ], 'k:' )
hold off;

xlabel( 'y (m)' );
ylabel( 'z (m)' );
graph_defaults;

