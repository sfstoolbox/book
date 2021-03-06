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

% Fig. 5.42(b), (d), and (f) will be created

alpha_s  = -pi/2;
beta_s   =  pi/2;
r_s      = 0.5;
L        = 56;
M        = 27;
R        = 1.5;
    
no_of_frequency_bins = 1025;

fs   = 44100;
c    = 343;
f    = linspace( 0, fs, no_of_frequency_bins + 1 );
f    = f( 1 : end/2 ).';
k    = 2.*pi.*f./c;
k(1) = k(2); % to avoid numerical instabilities

% time instances to plot
t_to_show    = [ -0.0013, 0, 0.0013 ];  % in sec
taps_to_show = round( t_to_show * fs + 1540  );

d_alpha_0 = 2*pi/L;

% initialize S_breve and G_breve
S_breve = zeros( length(f), 2*M+1 );
G_breve = zeros( length(f), 2*M+1 );

for m = -M : M

    % Eq. (2.37a)
    S_breve( :, m+M+1 ) = -i .* k .* sphbesselh( abs(m), 2, k.*r_s ) .* sphharm( abs(m), -m, beta_s, alpha_s );
    
    % Eq. (2.37a)
    G_breve( :, m+M+1 ) = -i .* k .* sphbesselh( abs(m), 2, k.*R ) .* sphharm( abs(m), -m, pi/2, 0 );
    
end

% from Eq. (5.40)
N = floor( k .* r_s ) + 1; % avoid 0

% initialize w_breve
w_breve = zeros( size( S_breve ) );

% this loop evaluates Eq. (5.40)
for m = -M : M    
    w_breve( :, m+M+1 ) = 0.5 * ( cos( abs( m ) ./ N * pi ) + 1 );
    
    w_breve( abs( m ) > k.*r_s, m + M + 1 ) = 0;
end

% initialize D
D = zeros( length( f ), L );

% loop over all secondary sources
for l = 0 : L-1
    
    % this loop evaluates Eq.(3.49)
    for m = -M : M    
        alpha_0    = l * d_alpha_0;
        D( :,l+1 ) = D( :, l+1 ) + 1 / ( 2*pi*R ) .* w_breve( :, m+M+1 ) .* ...
                S_breve( :, m+M+1 ) ./ G_breve( :, m+M+1 ) .* exp( i .* m .* alpha_0 );    
        
    end
end

d = real( ifft( [ D; conj( flipud( D( 2 : end-1, : ) )  ) ] ) );

% move t = 0 to the center of the buffer
d = circshift( d, [ length(f)-1 0 ] );

% put zeros around to have some headroom
d = [ zeros( no_of_frequency_bins, L ); d; zeros( no_of_frequency_bins, L ) ];

% normalize
d = d ./ max(abs( d( : ) ) );

% create spatial grid
resolution = 400;
X          = linspace( -2, 2, resolution );
Y          = linspace( -2, 2, resolution );
[ x, y ]   = meshgrid( X, Y );


s          = zeros( size( x ) );
d_reshaped = zeros( size( x ) );

for tap = taps_to_show

    s          = zeros( size( x ) );
    d_reshaped = zeros( size( x ) );

    % this loop evaluates Eq.(5.69)
    for l = 1 : L

        x_0 = R * cos( (l-1) * d_alpha_0 );
        y_0 = R * sin( (l-1) * d_alpha_0 );

        r = sqrt( ( x-x_0 ).^2 + ( y-y_0 ).^2 );

        % from Eq. (5.67)
        t = ( tap/fs - r./c ) .* fs + 1; % in samples

        % Interpolate the impulse responses to find the values at instances
        % t, which correspond to the spatial locations that we are 
        % interested in. 
        d_reshaped = reshape( ...
                          interp1( ( 1 : size( d, 1 ) ), d( :, l ), t, 'linear' ), ...
                                                                resolution, resolution );

        % from Eq.(5.67)
        s( find( r > 0 ) ) = s( find( r > 0 ) ) + d_reshaped( find( r > 0 ) ) ./ r( find( r > 0 ) );

    end

    figure;

    imagesc( X, Y, 20*log10( abs( s ) ), [ -30 0 ] );

    hold on;

    % plot secondary sources
    plot( R .* cos( ( 0 : L-1 ) .* d_alpha_0 ), R .* sin( ( 0 : L-1 ) .* d_alpha_0), 'kx' );
    
    % plot location of focused source
    plot( r_s * cos( alpha_s ), r_s * sin( alpha_s ), 'k.' )

    hold off;

    axis square;
    turn_imagesc;
    colormap gray;
    revert_colormap;
    colorbar;
    xlabel( 'x (m)' );
    ylabel( 'y (m)' );

    graph_defaults;

end % tap
