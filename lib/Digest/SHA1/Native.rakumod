unit module Digest::SHA1::Native;

use NativeCall;

constant SHA1 = %?RESOURCES<libraries/sha1>;

sub compute_sha1(Blob, size_t, CArray[uint8]) is native( SHA1 ) { * }
sub sha1_stream_ctx_size(--> size_t) is native( SHA1 ) { * }
sub sha1_stream_init(CArray[uint8]) is native( SHA1 ) { * }
sub sha1_stream_update(CArray[uint8], Blob, size_t) is native( SHA1 ) { * }
sub sha1_stream_final(CArray[uint8], CArray[uint8]) is native( SHA1 ) { * }

multi sub sha1-hex(Str $in) is export {
    sha1-hex($in.encode);
}

multi sub sha1-hex(Blob $in) is export {
    my size_t $len = $in.elems;

    my CArray[uint8] $hash .= new;
    $hash[79] = 0;

    compute_sha1($in,$len,$hash);

    my $str = $hash.list».chr.join.lc;

    return $str.substr(0,40);
}

my sub hexify(Blob:D $b --> Str) { $b.list.fmt('%02x','') }

multi sub sha1(Supply:D $in) is export {
  my $ctx = CArray[uint8].allocate(sha1_stream_ctx_size());
  sha1_stream_init($ctx);
  react whenever $in -> $chunk {
    my $blob = $chunk ~~ Blob ?? $chunk !! $chunk.Str.encode;
    sha1_stream_update($ctx, $blob, $blob.elems) if $blob.elems;
  }
  my $digest = CArray[uint8].allocate(20);
  sha1_stream_final($ctx, $digest);
  Blob.new($digest.list);
}

multi sub sha1(IO::Handle:D $in, Int:D :$chunk-size = 64 * 1024) is export {
  sha1 supply {
    while $in.read($chunk-size) -> $buf { emit $buf }
  }
}

multi sub sha1(IO::Path:D $in, Int:D :$chunk-size = 64 * 1024) is export {
  my $fh = $in.open(:r, :bin);
  LEAVE $fh.close;
  sha1($fh, :$chunk-size);
}

multi sub sha1-hex(Supply:D $in) is export { hexify sha1 $in }
multi sub sha1-hex(IO::Handle:D $in, Int:D :$chunk-size = 64 * 1024) is export {
  hexify sha1 $in, :$chunk-size;
}
multi sub sha1-hex(IO::Path:D $in, Int:D :$chunk-size = 64 * 1024) is export {
  hexify sha1 $in, :$chunk-size;
}

multi sub sha1($in) is export {
    Blob.new( sha1-hex($in).comb(2).map({ :16($_) }))
}
