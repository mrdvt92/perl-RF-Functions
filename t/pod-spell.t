use Test::More;
eval "use Test::Spelling";
plan skip_all => "Test::Spelling required for testing POD spelling" if $@;
add_stopwords(<DATA>);
all_pod_files_spelling_ok();

__DATA__
MRDVT
db2ratio
log10
ratio2db
dBi
dBd
dbd2dbi
dbi2dbd
CFR
unrounded
