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
% (c) 2012 by Jens Ahrens                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

subfigure = 'a'; % for Fig. 5.46(a)
%subfigure = 'b'; % for Fig. 5.46(b)
%subfigure = 'c'; % for Fig. 5.46(c)
%subfigure = 'd'; % for Fig. 5.46(d)

v     = 600;
f     = 500; 
t     = 0;
c     = 343; 
omega = 2*pi*f;
M     = v / c;

% create spatial grid
X        = linspace( -4, 2, 500 );
Y        = linspace( -3, 3, 500 );
[ x, y ] = meshgrid( X, Y );
z        = 0;

% Eq. (5.58)
Delta = sqrt( ( x - v*t ).^2  + ( y.^2 + z.^2 ) .* ( 1 - M^2 ) );

% Eq. (5.64)
tau_1 = ( M .* ( x - v*t ) + Delta ) / ( c * ( 1 - M^2 ) );
tau_2 = ( M .* ( x - v*t ) - Delta ) / ( c * ( 1 - M^2 ) );

% initialize s
s = zeros( size( x ) );

% Eq. (5.63) and (5.62), first case
if ( subfigure ~= 'c' )
    s = s + 1 / (4*pi) .* exp( i .* omega .* ( t - tau_1 ) ) ./ Delta;
end

if ( subfigure ~= 'd' )
    s = s + 1 / (4*pi) .* exp( i .* omega .* ( t - tau_2 ) ) ./ Delta;
end

% determine second case of Eq. (5.62)
validity = zeros( size( x ) );
sqrt_arg = ( y.^2 ) ./( c^2 ) .* ( 1 - M^2 ) + ( M*t - x/c ).^2;

validity( sqrt_arg > 0 ) = 1;   
validity( x > v*t )      = 0;

s = s .* validity;

% normalize
s = s ./ abs( s( end/2, end/2 ) );

figure;
if ( subfigure ~= 'b' )
    imagesc( X, Y, real( s ), [ -5 5 ] );
else
    imagesc( X, Y, 20*log10( abs( s ) + 5*eps ), [ -50 10 ] ); % avoid log of 0
    colorbar;
end

turn_imagesc;
axis square;
colormap gray;

if ( subfigure == 'b' )
    revert_colormap;
end

hold on;
% plot trajectory
plot( [ -4 2 ], [ 0 0 ], 'k:' )
hold off;

xlabel( 'x (m)' )
ylabel( 'y (m)' )

graph_defaults;
