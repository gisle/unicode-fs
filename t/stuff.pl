use Unicode::FS ':all';
use Unicode::Normalize qw(NFC);

sub do_fs_stuff {
    my $dir = shift || "dir";
    my $base = shift || "file";

    rmtree($dir) if -d encode_fs($dir);

    ok(mkdir($dir));
    ok(-d encode_fs($dir));
    for (1..5) {
	ok(file_bytes("$dir/$base-$_", $_), undef);
    }
    ok(file_bytes("$dir/$base-1"), "1");
    ok(file_bytes("$dir/$base-1", "1a"), "1");
    ok(file_bytes("$dir/$base-1", "1"), "1a");
    ok(mkdir("$dir/$dir-2"));
    ok(mkdir("$dir/$dir-10"));
    ok(mkdir("$dir/$dir-1"));

    my @files = sort(listdir($dir));
    ok(@files, 8);
    ok(NFC($files[-1]), "$base-5");

    #system("find $dir -ls");
    ok(rmtree($dir));
}
