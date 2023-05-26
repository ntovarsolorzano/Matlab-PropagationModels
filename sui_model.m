%  SUI propagation path loss model Logic
%  =====================================
%  The SUI model covers three terrain categories.
%  Category A represents the maximum path-loss category which is a hill terrain,
%  Category B represents an intermediate path-loss category, and
%  Category C represents the minimum path-loss category with mostly flat terrains.

%f = 2000; % MHz
%d = 5; % km
%ht = 50; % meters
%hr = 10; % meters
%terrain_type = 'A';

PLsui = sui(f, d, ht, hr, terrain_type);


function PLsui = sui(f, d, ht, hr, terrain_type)
    % f - frequency in MHz
    % d - distance between Tx and Rx in km
    % ht - Tx antenna height in meters
    % hr - Rx antenna height in meters
    % terrain_type - 'A', 'B', or 'C'
    
    % Constants
    d0 = 0.1; % km
    c = 3e8; % speed of light (m/s)
    lambda = c / (f * 1e6); % wavelength (m)
    
    % Calculate intercept (A)
    A = 20 * log10((4 * pi * d0 * 1e3) / lambda);
    
    % Calculate path loss exponent (gamma)
    if strcmp(terrain_type, 'A')
        a = 4.6;
        b = 0.0075;
        c = 12.6;
        sigma_gamma = 0.57;
        mu_sigma = 10.6;
        sigma_sigma = 2.3;
    elseif strcmp(terrain_type, 'B')
        a = 4.0;
        b = 0.0065;
        c = 17.1;
        sigma_gamma = 0.75;
        mu_sigma = 9.6;
        sigma_sigma = 3.0;
    elseif strcmp(terrain_type, 'C')
        a = 3.6;
        b = 0.005;
        c = 20.0;
        sigma_gamma = 0.59;
        mu_sigma = 8.2;
        sigma_sigma = 1.6;
    else
        error('Invalid terrain type. Must be "A", "B", or "C".')
    end
    
    x = randn; % zero-mean Gaussian variable N[0,1]
    gamma = a - (b * ht) + (c / ht) + x * sigma_gamma;
    
    % Calculate shadow fading component (s)
    y = 0; %randn; % zero-mean Gaussian variable N[0,1] ~ Uncomment if needed
    z = 0; %randn; % zero-mean Gaussian variable N[0,1] ~ Uncomment if needed
    sigma = mu_sigma + z * sigma_sigma;
    s = y * sigma;
    
    % Calculate SUI path loss
    PLsui = A + (10 * gamma * log10(d / d0)) + s;
    
    % Corrective action for other frequency and receiver antenna heights
    PLdeltaf = 6 * log10(f / 2000);
    
    if strcmp(terrain_type, 'A') || strcmp(terrain_type, 'B')
        PLdeltah = -10.8 * log10(hr / 2);
    elseif strcmp(terrain_type, 'C')
        PLdeltah = -20 * log10(hr / 2);
    end
    
    PLsui = PLsui + PLdeltaf + PLdeltah;
end
