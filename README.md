[![Actions Status](https://github.com/bduggan/raku-digest-sha1-native/actions/workflows/linux.yml/badge.svg)](https://github.com/bduggan/raku-digest-sha1-native/actions/workflows/linux.yml)
[![Actions Status](https://github.com/bduggan/raku-digest-sha1-native/actions/workflows/macos.yml/badge.svg)](https://github.com/bduggan/raku-digest-sha1-native/actions/workflows/macos.yml)
[![Actions Status](https://github.com/bduggan/raku-digest-sha1-native/actions/workflows/windows.yml/badge.svg)](https://github.com/bduggan/raku-digest-sha1-native/actions/workflows/windows.yml)

NAME
====

Digest::SHA1::Native -- Fast SHA1 computation using NativeCall to C.

SYNOPSIS
========

    use Digest::SHA1::Native;

    say sha1-hex("The quick brown fox jumps over the lazy dog");
    say sha1-hex("The quick brown fox jumps over the lazy dog".encode);
    say sha1("The quick brown fox jumps over the lazy dog")».fmt('%02x').join;

Output:

    2fd4e1c67a2d28fced849ee1bb76e7391b93eb12
    2fd4e1c67a2d28fced849ee1bb76e7391b93eb12
    2fd4e1c67a2d28fced849ee1bb76e7391b93eb12

DESCRIPTION
===========

`sha1-hex` accepts a string or bytes (a Buf or Blob) and returns a hex string.

`sha1` converts the hex into binary (i.e. it returns a Blob).

EXAMPLES
========

From <https://en.wikipedia.org/wiki/Hash-based_message_authentication_code#Examples>:

    use Digest::HMAC;
    use Digest::SHA1::Native;

    say hmac-hex("key","The quick brown fox jumps over the lazy dog",&sha1);

Output:

    de7c9b85b8b78aa6bc8a7a36f70a90701c9db4d9

SHA1 IMPLEMENTATION
===================

The C implementation in [src/sha1.c](src/sha1.c) is a public-domain SHA-1
descended from Steve Reid's original. Authors of that file, in order of
contribution:

* Steve Reid

* James H. Brown

* Saul Kravitz

* Ralph Giles

* Jonathan Worthington

* Brian Duggan

AUTHOR
======

Brian Duggan (bduggan at matatu.org)

CONTRIBUTORS
============

* Altai-man

* David Warring

* Jonathan Worthington

* Nick Logan

* Stefan Seifert (niner)

* Zoffix Znet
