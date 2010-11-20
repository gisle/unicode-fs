package Unicode::FS;

use strict;
use warnings;

our $VERSION = "0.01";

use base 'Exporter';
our @EXPORT_OK = qw(
    encode_fs decode_fs
    mkdir rmdir mkpath rmtree
    opendir readdir listdir
    file_bytes
);
our %EXPORT_TAGS = (
    all => \@EXPORT_OK,
);

use Encode qw(encode decode);
use Encode::Locale ();

sub encode_fs {
    return encode(locale_fs => my $f = $_[0], Encode::FB_CROAK);
}

sub decode_fs {
    return decode(locale_fs => my $f = $_[0], Encode::FB_CROAK);
}

sub mkdir {
    my $dirname = encode_fs(@_ ? shift : $_);
    print "mkdir $dirname\n";
    return CORE::mkdir($dirname, @_ ? $_[0] : 0777);
}

sub rmdir {
    my $dirname = encode_fs(@_ ? shift : $_);
    print "rmdir $dirname\n";
    return CORE::rmdir($dirname);
}

sub rmtree {
    my $dirname = encode_fs(shift) || die;
    print "rmtree $dirname\n";
    require File::Path;
    return File::Path::rmtree($dirname);
}

sub opendir {
    return CORE::opendir($_[0], encode_fs($_[1]));
}

sub readdir {
    if (wantarray) {
	return map decode_fs($_), CORE::readdir($_[0]);
    }
    else {
	return decode_fs(CORE::readdir($_[0]));
    }
}

sub listdir {
    die "listdir not called in list context" unless wantarray;

    my $dir = shift;
    &opendir(my $dh, $dir) || die "Can't open '$dir': $!";
    my @files = &readdir($dh);
    return grep !/^\.\.?\z/, @files;
}

sub file_bytes {
    my $name = shift;
    my $name_enc = encode_fs($name);

    my $old;
    if (defined wantarray and open(my $f, "<", $name_enc)) {
	binmode($f);
	local $/;
	$old = scalar <$f>;
    }

    if (@_) {
        my $f;
        unless (open($f, ">", $name_enc)) {
            my $err = $!;
            if (!-e $name) {
                # does it help to create the directory first
                require File::Basename;
                require File::Path;
                my $dirname = File::Basename::dirname($name);
                if (File::Path::mkpath($dirname)) {
                    # retry
                    undef($err);
                    unless (open($f, ">", $name_enc)) {
                        $err = $!;
                    }
                }
            }
            die "Can't create '$name': $err" if $err;
        }
        binmode($f);
	if ($_[1]) {
	    print $f encode($_[1], $_[0]);
	}
	else {
	    utf8::downgrade($_[0]);
	    print $f $_[0];
	}
        close($f) || die "Can't write to '$name': $!";
    }

    return $old;
}

sub unlink {
    if (@_) {
	return CORE::unlink(map encode_fs($_), @_);
    }
    else {
	return CORE::unlink(encode_fs($_));
    }
}

1;
