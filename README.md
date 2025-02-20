# NAME

RF::Functions - Perl Exporter for Radio Frequency (RF) Functions

# SYNOPSIS

    use RF::Functions qw{db_ratio ratio_db};
    my $db = db_ratio(2); #~3dB

# DESCRIPTION

RF::Functions is a lib for common RF function.  I plan to add additional functions as I need them.

# FUNCTIONS

## db\_ratio, ratio2db

Returns dB given a numerical power ratio.

    my $db = db_ratio(2);   #+3dB
    my $db = db_ratio(1/2); #-3dB

## ratio\_db, db2ratio

Returns power ratio given dB.

    my $power_ratio = ratio_db(3); #2

## dbi\_dbd, dbd2dbi

Returns dBi given dBd.  Converts the given antenna gain in dBd to dBi.

    my $eirp = dbi_dbd($erp);

## dbd\_dbi, dbi2dbd

Returns dBd given dBi. Converts the given antenna gain in dBi to dBd.

    my $erp = dbd_dbi($eirp);

## dipole\_gain

Returns the gain of a reference half-wave dipole in dBi.

    my $dipole_gain = dipole_gain(); #always 2.15 dBi

## fsl\_hz\_m, fsl\_mhz\_km, fsl\_ghz\_km, fsl\_mhz\_mi

Return power loss in dB given frequency and distance in the specified units of measure

    my $free_space_loss = fsl_mhz_km($mhz, $km); #returns dB

## okumura\_hata\_env\_mhz\_km\_m\_m

Returns power loss in dB given environment code, frequency, distance, base station height, and mobile station height.

    my $loss_db = $rf->okumura_hata_env_mhz_km_m_m($environment_code, $frequency_mhz, $distance_km, $height_base_station_m, $height_mobile_station_m);
    my $loss_db = $rf->okumura_hata_env_mhz_km_m_m('d', 902, 4.3, 30, 1.5);

Propagation Model Parameters and Limitation:

    Environment code (d => dense urban area, m => medium urban area, s => suburban area, o => open area)
    Frequency (150 - 1500 MHz)
    Distance between the base and mobile station (1 - 20km)
    Height of the base station antenna (30 - 200m)
    Height of the station antenna (1 - 10m)

Implementation based on [https://en.wikipedia.org/wiki/Hata\_model](https://en.wikipedia.org/wiki/Hata_model).

## distance\_fcc

Returns the unrounded distance between the two reference points in kilometers using the formula in 47 CFR 73.208(c). This formula is valid only for distances not exceeding 475 km (295 miles).

    my $distance_km  = distance_fcc($lat1, $lon1, $lat2, $lon2); #reference points latitude and longitude pair in decimal degrees
    my $distance_fcc = Math::Round::round($distance_km); 47 CFR 73.208(c)(8)

The FCC's formula is also defined in 47 CFR 1.958 and discussed on [Wikipedia](https://en.wikipedia.org/wiki/Geographical_distance#FCC&#x27;s_formula)

# SEE ALSO

["log10" in POSIX](https://metacpan.org/pod/POSIX#log10), ["nearest" in Math::Round](https://metacpan.org/pod/Math%3A%3ARound#nearest)

[https://en.wikipedia.org/wiki/Decibel#Power\_quantities](https://en.wikipedia.org/wiki/Decibel#Power_quantities)

[https://en.wikipedia.org/wiki/Free-space\_path\_loss#Free-space\_path\_loss\_in\_decibels](https://en.wikipedia.org/wiki/Free-space_path_loss#Free-space_path_loss_in_decibels)

[https://en.wikipedia.org/wiki/Dipole\_antenna#Dipole\_as\_a\_reference\_standard](https://en.wikipedia.org/wiki/Dipole_antenna#Dipole_as_a_reference_standard)

# AUTHOR

Michael R. Davis, MRDVT

# COPYRIGHT AND LICENSE

MIT LICENSE

Copyright (C) 2023 by Michael R. Davis
