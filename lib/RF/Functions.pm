package RF::Functions;
use strict;
use warnings;
use POSIX qw{log10};
use base qw{Exporter};
use Math::Round qw{};

our $PACKAGE   = __PACKAGE__;
our $VERSION   = '0.04';
our @EXPORT_OK = qw(
                    db_ratio ratio2db
                    ratio_db db2ratio
                    fsl_hz_m fsl_mhz_km fsl_ghz_km fsl_mhz_mi
                    dbd_dbi dbi_dbd dbd2dbi dbi2dbd dipole_gain
                    distance_fcc
                   );

=head1 NAME

RF::Functions - Perl Exporter for Radio Frequency (RF) Functions

=head1 SYNOPSIS

  use RF::Functions qw{db_ratio ratio_db};
  my $db = db_ratio(2); #~3dB

=head1 DESCRIPTION

RF::Functions is a lib for common RF function.  I plan to add additional functions as I need them.

=head1 FUNCTIONS

=head2 db_ratio, ratio2db

Returns dB given a numerical power ratio.

  my $db = db_ratio(2);   #+3dB
  my $db = db_ratio(1/2); #-3dB

=cut

sub db_ratio {10 * log10(shift())};

sub ratio2db {10 * log10(shift())};

=head2 ratio_db, db2ratio

Returns power ratio given dB.

  my $power_ratio = ratio_db(3); #2

=cut

sub ratio_db {10 ** (shift()/10)};

sub db2ratio {10 ** (shift()/10)};

=head2 dbi_dbd, dbd2dbi

Returns dBi given dBd.  Converts the given antenna gain in dBd to dBi.

  my $eirp = dbi_dbd($erp);

=cut

sub dbi_dbd {shift() + dipole_gain()};

sub dbd2dbi {shift() + dipole_gain()};

=head2 dbd_dbi, dbi2dbd

Returns dBd given dBi. Converts the given antenna gain in dBi to dBd.

  my $erp = dbd_dbi($eirp);

=cut

sub dbd_dbi {shift() - dipole_gain()};

sub dbi2dbd {shift() - dipole_gain()};

=head2 dipole_gain

Returns the gain of a reference half-wave dipole in dBi.

  my $dipole_gain = dipole_gain(); #always 2.15 dBi

=cut

sub dipole_gain {2.15}; #FCC 10Log(1.64) ~ 2.15

=head2 fsl_hz_m, fsl_mhz_km, fsl_ghz_km, fsl_mhz_mi

Return power loss in dB given frequency and distance in the specified units of measure

  my $free_space_loss = fsl_mhz_km($mhz, $km); #returns dB

=cut

sub fsl_hz_m {
  my ($f, $d) = @_;
  return _fsl_constant($f, $d, -147.55);
}

sub fsl_mhz_km {
  my ($f, $d) = @_;
  return _fsl_constant($f, $d, 32.45);
}

sub fsl_ghz_km {
  my ($f, $d) = @_;
  return _fsl_constant($f, $d, 92.45);
}

sub fsl_mhz_mi {
  my ($f, $d) = @_;
  return _fsl_constant($f, $d, 36.58); #const = 20*log10(4*pi/c) where c = 0.186282397 mi/μs (aka mile * MHz)
}

sub _fsl_constant {
  my $freq  = shift; die("Error: Frequency must be positive number") unless $freq > 0;
  my $dist  = shift; die("Error: Distance must be non-negative number") unless $dist >= 0;
  my $const = shift or die("Error: Constant required");
  #Equvalent to 20log($freq) + 20log($dist) + $const for performance
  return Math::Round::nearest(0.001, 20 * log10($freq * $dist) + $const);
}

=head2 distance_fcc

Returns the unrounded distance between the two reference points in kilometers using the formula in 47 CFR 73.208(c). This formula is valid only for distances not exceeding 475 km (295 miles).

  my $distance_km  = distance_fcc($lat1, $lon1, $lat2, $lon2); #reference points latitude and longitude pair in decimal degrees
  my $distance_fcc = Math::Round::round($distance_km); 47 CFR 73.208(c)(8)

=cut

my $RADIANS_PER_DEGREE = CORE::atan2(1, 1)/45;

sub _cos_dd {cos(shift() * $RADIANS_PER_DEGREE)};

sub distance_fcc {
  my $LAT1_dd = shift;                                              # the coordinates of the first reference point in degree-decimal format.
  my $LON1_dd = shift;
  my $LAT2_dd = shift;                                              # the coordinates of the second reference point in degree-decimal format.
  my $LON2_dd = shift;
  #(2) Calculate the middle latitude between the two reference points by averaging the two latitudes as follows:
  #ML = (LAT1_dd + LAT2_dd) ÷ 2;                                    # the middle latitude in degree-decimal format.
  my $ML      = ($LAT1_dd + $LAT2_dd) / 2;

  #(3) Calculate the number of kilometers per degree latitude difference for the middle latitude calculated in paragraph (c)(2) as follows:
  #KPDlat = 111.13209 - 0.56605 cos(2ML) + 0.00120 cos(4ML)         #the number of kilometers per degree of latitude at a given middle latitude.
  my $KPD_lat = 111.13209 - 0.56605 * _cos_dd(2 * $ML) + 0.00120 * _cos_dd(4 * $ML);

  #(4) Calculate the number of kilometers per degree longitude difference for the middle latitude calculated in paragraph (c)(2) as follows:
  #KPDlon = 111.41513 cos(ML) − 0.09455 cos(3ML) + 0.00012 cos(5ML) # the number of kilometers per degree of longitude at a given middle latitude.
  my $KPD_lon = 111.41513 * _cos_dd($ML) - 0.09455 * _cos_dd(3 * $ML) + 0.00012 * _cos_dd(5 * $ML);

  #(5) Calculate the North-South distance in kilometers as follows:
  #NS = KPDlat(LAT1_dd−LAT2_dd)                                     # the North-South distance in kilometers.
  my $NS      = $KPD_lat * ($LAT1_dd - $LAT2_dd);

  #(6) Calculate the East-West distance in kilometers as follows:
  #EW = KPDlon(LON1_dd−LON2_dd)                                     # the East-West distance in kilometers.
  my $EW      = $KPD_lon * ($LON1_dd - $LON2_dd);

  #(7) Calculate the distance between the two reference points by taking the square root of the sum of the squares of the East-West and North-South distances as follows:
  #DIST = (NS^2 + EW^2)^0.5                                         # the distance between the two reference points, in kilometers.
  my $DIST    = sqrt($NS**2 + $EW**2);

  warn("Package: $PACKAGE, Function: distance_fcc, This formula is valid only for distances not exceeding 475 km (295 miles).\n") if $DIST > 475;
  return $DIST;
}

=head1 SEE ALSO

L<POSIX/log10>, L<Math::Round/nearest>

L<https://en.wikipedia.org/wiki/Decibel#Power_quantities>

L<https://en.wikipedia.org/wiki/Free-space_path_loss#Free-space_path_loss_in_decibels>

L<https://en.wikipedia.org/wiki/Dipole_antenna#Dipole_as_a_reference_standard>

=head1 AUTHOR

Michael R. Davis, MRDVT

=head1 COPYRIGHT AND LICENSE

MIT LICENSE

Copyright (C) 2023 by Michael R. Davis

=cut

1;
