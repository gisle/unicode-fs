#!perl

use utf8;
use strict;
use warnings;

use Test qw(plan ok);
plan tests => 14;

do 't/stuff.pl';
do_fs_stuff("dür", "für");
