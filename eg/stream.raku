#!raku

use Digest::SHA1::Native;

say sha1-hex("The quick brown fox jumps over the lazy dog");

say sha1-hex supply {
   emit "The quick brown fox ";
   emit "jumps over the lazy dog"
}
