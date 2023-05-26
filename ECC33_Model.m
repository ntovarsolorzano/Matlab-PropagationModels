% * For medium cities,
% * Gr = (42.57 + (13.7*log10(f)))*((log10(Hr)) - 0.585 ) ------------------------------------------- eq 5
% * 
% * For large cities,
% * Gr = ( 0.759 * Hr ) - 1.892 -------------------------------------------------------------------- eq 6
% * 
% * Hb - Tx Antenna Height in meters;
% * Hr - Rx Antenna Height;
% * d - distance between Tx and Rx in Km; 
% * f - Frequeny in Ghz;


%f = 2; % GHz
%d = 5; % km
%Hb = 50; % meters
%Hr = 10; % meters
%city_size = 'medium';

%PLecc33 = ecc33(f, d, Hb, Hr, city_size);


% * For medium cities,
% * Gr = (42.57 + (13.7*log10(f)))*((log10(Hr)) - 0.585 ) ------------------------------------------- eq 5
% * 
% * For large cities,
% * Gr = ( 0.759 * Hr ) - 1.892 -------------------------------------------------------------------- eq 6
% * 
% * Hb - Tx Antenna Height in meters;
% * Hr - Rx Antenna Height;
% * d - distance between Tx and Rx in Km; 
% * f - Frequeny in Ghz;


%f = 2; % GHz
%d = 5; % km
%Hb = 50; % meters
%Hr = 10; % meters
%city_size = 'medium';

%PLecc33 = ecc33(f, d, Hb, Hr, city_size);


function PLecc33 = ecc33(f, d, Hb, Hr, city_size)
    % f - frequency in GHz
    % d - distance between Tx and Rx in km
    % Hb - Tx antenna height in meters
    % Hr - Rx antenna height in meters
    % city_size - 'medium' or 'large'
    
    % Calculate free space attenuation (Afs)
    Afs = 92.4 + (20 * log10(d)) + (20 * log10(f));
    
    % Calculate basic median path loss (Abm)
    Abm = 20.41 + (9.83 * log10(d)) + (7.894 * log10(f)) + (9.56 * (log10(f)).^2);
    
    % Calculate transmitter antenna height gain factor (Gb)
    Gb = log10(Hb/200) * (13.958 + (5.8 * (log10(d)))).^2;
    
    % Calculate receiver antenna height gain factor (Gr)
    if strcmp(city_size, 'medium')
        Gr = (42.57 + (13.7 * log10(f))) * ((log10(Hr)) - 0.585);
    elseif strcmp(city_size, 'large')
        Gr = (0.759 * Hr) - 1.892;
    else
        error('Invalid city size. Must be "medium" or "large".')
    end
    
    % Calculate ECC-33 path loss
    PLecc33 = Afs + Abm - Gb - Gr;
end

