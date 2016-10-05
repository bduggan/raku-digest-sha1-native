unit module Digest::SHA1::Fast;

use NativeCall;

constant SHA1 = %?RESOURCES<libraries/sha1>.Str;

sub compute_sha1(CArray[uint8], size_t, CArray[uint8]) is native( SHA1 ) { * }

multi sub sha1-hex(Str $in) is export {
    sha1-hex($in.encode);
}

multi sub sha1-hex($in) is export {
    my $text = CArray[uint8].new;

    $text[$_] = $in[$_] for 0..$in.elems-1;

    my size_t $len = $in.elems;

    my CArray[uint8] $hash .= new;
    $hash[79] = 0;

    compute_sha1($text,$len,$hash);

    my $str = $hash.list».chr.join.lc;

    return $str.substr(0,40);
}


