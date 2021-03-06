
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

% both Fig. 3.14(a) and (b) will be created 

theta_pw = pi/4;
phi_pw   = pi/2;
f        = 1000; % Hz
c        = 343;  % m/s
k        = (2*pi*f)/c;

k_pw_x = k * cos( theta_pw ) * sin( phi_pw );
k_pw_y = k * sin( theta_pw ) * sin( phi_pw );
k_pw_z = k * cos( phi_pw );

% create spatial grid
X        = linspace( -2, 2, 200 );
Y        = linspace( -1, 3, 200 );
[ x, y ] = meshgrid( X, Y );
z        = 0;

% Sec. 3.6.3: Desired field is perfectly synthesized thought mirrored
% at the x-z-plane
S = exp( -i .* ( k_pw_x .* x + k_pw_y .* abs( y ) + k_pw_z .* z ) ); % Eq. (1.1)

% Fig. 3.14(a)
figure;
imagesc( X, Y, real( S ), [ -2 2 ] );
turn_imagesc;
colormap gray;
axis square;

hold on;
% plot secondary source distribution
plot( [ -2 2 ],  [ 0 0 ], 'k', 'Linewidth', 2 )
hold off;

xlabel( 'x (m)' );
ylabel( 'y (m)' );
graph_defaults;

% Fig. 3.14(b)
figure;
imagesc( X, Y, 20*log10 ( abs( S ) ), [ -10 10 ] );
turn_imagesc;
colormap gray;
revert_colormap;
colorbar;
axis square;

hold on;
% plot secondary source distribution
plot( [ -2 2 ],  [ 0 0 ], 'k', 'Linewidth', 2 )
hold off;

xlabel( 'x (m)' );
ylabel( 'y (m)' );
graph_defaults;

