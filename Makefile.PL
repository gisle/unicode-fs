require 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	   => 'Unicode::FS',
    'VERSION_FROM' => 'lib/Unicode/FS.pm',
    'PREREQ_PM'    => {
	'Encode' => 2,
	'Encode::Locale' => 0.02,
    },
);
