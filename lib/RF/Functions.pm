package RF::Functions;
use strict;
use warnings;
use POSIX qw{log10};
use base qw{Exporter};

our $VERSION = '0.01';
our @EXPORT_OK = qw(db_ratio ratio2db ratio_db db2ratio fsl_mhz_km);

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

=head2 fsl_mhz_km

Return power loss in dB given frequency in MHz and distance in km

  my $free_space_loss = fsl_mhz_km($mhz, $km); #returns dB

=cut

sub fsl_mhz_km {
  my $freq_mhz = shift;
  my $dist_km  = shift;
  #Equvalent to 20log($f_mhz) + 20log($d_km) + 32.45 for performance
  return _round(20 * log10($freq_mhz * $dist_km) + 32.45, 0.001); #32.45 from FCC OET Engineering Tools
}

sub _round {
  my $num = shift;
  my $div = shift || 1;
  return int($num / $div + 0.5) * $div;
}

=head1 SEE ALSO

L<POSIX> log10

=head1 AUTHOR

Michael R. Davis, MRDVT

=head1 COPYRIGHT AND LICENSE

MIT LICENSE

Copyright (C) 2022 by Michael R. Davis

=cut

1;
