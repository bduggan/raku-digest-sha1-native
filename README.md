Digest::SHA1::Native
=======
* Travis: [![Build Status](https://travis-ci.org/bduggan/p6-sha1-native.svg)](https://travis-ci.org/bduggan/p6-sha1-native)

Description
===========
Fast SHA1 calculations using NativeCall to C.

Synopsis
========
`sha1-hex` accepts bytes or a string.

```
use Digest::SHA1::Native;

say sha1-hex("The quick brown fox jumps over the lazy dog")
```
2fd4e1c67a2d28fced849ee1bb76e7391b93eb12

```
say sha1-hex("The quick brown fox jumps over the lazy dog".encode)
```
2fd4e1c67a2d28fced849ee1bb76e7391b93eb12

`sha1` converts the hex into binary.

Examples
========
```
use Digest::HMAC
use Digest::SHA1::Native;

say hmac-hex("key","The quick brown fox jumps over the lazy dog",&sha1);

```

```
de7c9b85b8b78aa6bc8a7a36f70a90701c9db4d9
```

See https://en.wikipedia.org/wiki/Hash-based_message_authentication_code
