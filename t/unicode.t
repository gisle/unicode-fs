#!perl

use strict;
use warnings;

use Test qw(plan ok);
plan tests => 14;

do 't/stuff.pl';
do_fs_stuff("dir\x{20AC}", "fil\x{20AC}");
