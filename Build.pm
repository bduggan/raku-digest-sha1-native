use v6;
use LibraryMake;
use Shell::Command;

class Build {
    method build($dir) {
        if Rakudo::Internals.IS-WIN {
            note "Using pre-built DLL on Windows";
            return True;
        }
        my %vars = get-vars($dir);
        %vars<sha1> = $*VM.platform-library-name('sha1'.IO);
        mkdir "$dir/resources" unless "$dir/resources".IO.e;
        mkdir "$dir/resources/libraries" unless "$dir/resources/libraries".IO.e;
        process-makefile($dir, %vars);
        my $goback = $*CWD;
        chdir($dir);
        shell(%vars<MAKE>);
        chdir($goback);
        True;
    }
}

