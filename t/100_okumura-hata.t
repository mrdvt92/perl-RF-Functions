use strict;
use warnings;
use Test::More tests => 4;
use Test::Number::Delta;
use RF::Functions qw{okumura_hata_env_mhz_km_m_m};

#
# The test values 137.93, 137.88, and 128.03 are covered by the GPL 2.0 license
#
# Copyright (c) 2011,2012 Centre Tecnologic de Telecomunicacions de Catalunya (CTTC)
#
# SPDX-License-Identifier: GPL-2.0-only
#
# Author: Marco Miozzo <marco.miozzo@cttc.es>
#         Nicola Baldo <nbaldo@cttc.es>
#

#test cases from https://www.nsnam.org/docs/doxygen/d7/dd9/okumura-hata-test-suite_8cc_source.html
delta_within(okumura_hata_env_mhz_km_m_m('d', 896, 2, 30, 1), 137.93, 0.5, 'okumura_hata_env_mhz_km_m_m dense urban');
delta_within(okumura_hata_env_mhz_km_m_m('m', 896, 2, 30, 1), 137.88, 0.5, 'okumura_hata_env_mhz_km_m_m medium urban');
delta_within(okumura_hata_env_mhz_km_m_m('s', 896, 2, 30, 1), 128.03, 0.5, 'okumura_hata_env_mhz_km_m_m suburban');

# The test value 109.66 (public domain) is an average value between the NSNAM and Perl implementations

delta_within(okumura_hata_env_mhz_km_m_m('o', 896, 2, 30, 1), 109.66, 0.5, 'okumura_hata_env_mhz_km_m_m open');
#NSNAM Open Area implementation (as of 2025-02-19) had a bug 4.70 vs 4.78
#See: https://gitlab.com/nsnam/ns-3-dev/-/merge_requests/2352/diffs
