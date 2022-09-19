use strict;
use warnings;
use Test::More tests => 17;
use Test::Number::Delta;
use RF::Functions qw{db_ratio ratio2db ratio_db db2ratio fsl_mhz_km};

delta_within(db_ratio(2),    3.0103, 1e-4, 'db_ratio');
delta_within(db_ratio(1/2), -3.0103, 1e-4, 'db_ratio');
delta_within(ratio2db(2),    3.0103, 1e-4, 'ratio2db');
delta_within(ratio2db(1/2), -3.0103, 1e-4, 'ratio2db');

delta_within(ratio_db(3),    2, 1e-2, 'ratio_db');
delta_within(ratio_db(-3),  1/2, 1e-2, 'ratio_db');
delta_within(db2ratio(3),    2, 1e-2, 'db2ratio');
delta_within(db2ratio(-3),  1/2, 1e-2, 'db2ratio');

delta_within(fsl_mhz_km(2400, 5), 114.03, 1e-2, 'fsl_mhz_km');

is(RF::Functions::_round(1.12345), 1);
is(RF::Functions::_round(0.12345), 0);
is(RF::Functions::_round(1.12345,0), 1);
is(RF::Functions::_round(1.12345,0.1), 1.1);
is(RF::Functions::_round(1.12345,0.01), 1.12);
is(RF::Functions::_round(1.12345,0.001), 1.123);
is(RF::Functions::_round(1.5), 2);
is(RF::Functions::_round(1.55, 0.1), 1.6);
