#!raku

use Digest::SHA1::Native;

# Hash a file, streamed from disk in bounded chunks -- never fully in memory.

my $path = @*ARGS[0] // $*PROGRAM;

say sha1-hex($path.IO);
