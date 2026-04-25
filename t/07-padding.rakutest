use Digest::SHA1::Native;
use Test;

# Padding boundary tests.
#
# SHA1 processes data in 64-byte blocks. The final block must contain a
# 0x80 sentinel byte, zero padding, and an 8-byte big-endian bit length
# in its last 8 bytes. Whether the trailer fits in the current block or
# spills into a fresh one depends on (message-length mod 64). The two
# branches in SHA1_Final are:
#
#   - len mod 64 in  [0, 55]  -> one final SHA1_Transform
#   - len mod 64 in [56, 63]  -> two final SHA1_Transforms
#
# These tests pin behavior at the j = 55 / 56 / 63 / 0 boundaries and
# at a few multi-block sizes including the historical "8K bug" range
# called out at the top of src/sha1.c.
#
# === How the expected values were generated ===
#
# Each entry in @cases below is a (length, hex-digest) pair. The digest
# is the SHA1 of (length copies of the byte 'a'). To regenerate or
# verify any single entry from the shell:
#
#     N=55
#     head -c $N /dev/zero | tr '\0' 'a' | openssl dgst -sha1
#
# To regenerate the whole table:
#
#     for n in 0 1 54 55 56 57 63 64 65 119 120 127 128 129 \
#              1000 8191 8192 8193; do
#         h=$(head -c "$n" /dev/zero | tr '\0' 'a' \
#             | openssl dgst -sha1 | awk '{print $NF}')
#         printf "    %d => '%s',\n" "$n" "$h"
#     done
#
# Note: do NOT use `printf 'a%.0s' $(seq 1 $n)` — bash printf emits
# the literal 'a' once even when given zero args, so n=0 silently
# becomes n=1.

my %expected =
    0    => 'da39a3ee5e6b4b0d3255bfef95601890afd80709',
    1    => '86f7e437faa5a7fce15d1ddcb9eaeaea377667b8',
    54   => 'b05d71c64979cb95fa74a33cdb31a40d258ae02e',
    55   => 'c1c8bbdc22796e28c0e15163d20899b65621d65a',
    56   => 'c2db330f6083854c99d4b5bfb6e8f29f201be699',
    57   => 'f08f24908d682555111be7ff6f004e78283d989a',
    63   => '03f09f5b158a7a8cdad920bddc29b81c18a551f5',
    64   => '0098ba824b5c16427bd7a1122a5a442a25ec644d',
    65   => '11655326c708d70319be2610e8a57d9a5b959d3b',
    119  => 'ee971065aaa017e0632a8ca6c77bb3bf8b1dfc56',
    120  => 'f34c1488385346a55709ba056ddd08280dd4c6d6',
    127  => '89d95fa32ed44a7c610b7ee38517ddf57e0bb975',
    128  => 'ad5b3fdbcb526778c2839d2f151ea753995e26a0',
    129  => 'd96debf1bdcbc896e6c134ea76e8141f40d78536',
    1000 => '291e9a6c66994949b57ba5e650361e98fc36b1ba',
    8191 => '850f361432d6af028751903eb3f58a4197f5d068',
    8192 => '2727756cfee3fbfe24bf5650123fd7743d7b3465',
    8193 => '3f5034a3c8446bc1f2f20ea05b5442c20b770161',
    ;

for %expected.keys.sort(*.Int) -> $n {
    is sha1-hex('a' x $n).lc, %expected{$n}, "len=$n ('a' x $n)";
}

# Binary / varied-content cases. Inputs are given as Buf so we exercise
# bytes that aren't valid text (NULs, the full 0..255 range).
#
# Regenerate from the shell, e.g.:
#
#     printf '\x00' | openssl dgst -sha1
#     head -c 64 /dev/zero | openssl dgst -sha1
#     for i in {0..255}; do printf "\\$(printf '%03o' $i)"; done \
#         | openssl dgst -sha1

my @binary =
    ( Buf.new(),                                  'da39a3ee5e6b4b0d3255bfef95601890afd80709', 'empty buf'                ),
    ( Buf.new(0x00),                              '5ba93c9db0cff93f52b521d7420e43f6eda2784f', 'single NUL byte'          ),
    ( Buf.new(0x00, 0x01, 0x02, 0x03,
              0x04, 0x05, 0x06, 0x07),            '67423ebfa8454f19ac6f4686d6c0dc731a3ddd6b', '8 sequential bytes'       ),
    ( Buf.new(0x00 xx 64),                        'c8d7d0ef0eedfa82d2ea1aa592845b9a6d4b02b7', '64 NUL bytes (one block)' ),
    ( Buf.new(0..255),                            '4916d6bdb7f78e6803698cab32d1586ea457dfc8', 'all 0..255 once (256 B)'  ),
    ;

for @binary -> ($buf, $expected, $label) {
    is sha1-hex($buf).lc, $expected, $label;
}

# Round-trip: digest(prefix) ++ digest(prefix ++ extra) must differ for
# any non-empty extra. Cheap sanity check that padding length is mixed
# in correctly (length-extension attacks aside, two different-length
# inputs must produce different digests).
my $a = sha1-hex('a' x 55);
my $b = sha1-hex('a' x 56);
isnt $a, $b, 'len 55 and 56 produce different digests';

my $c = sha1-hex('a' x 63);
my $d = sha1-hex('a' x 64);
isnt $c, $d, 'len 63 and 64 produce different digests';

done-testing;
