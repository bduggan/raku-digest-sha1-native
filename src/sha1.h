/* public api for steve reid's public domain SHA-1 implementation */
/* this file is in the public domain */

#ifndef __SHA1_H
#define __SHA1_H

#ifdef _WIN32
#define DLLEXPORT __declspec(dllexport)
#else
#define DLLEXPORT extern
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef struct {
    unsigned int  state[5];
    unsigned int  count[2];
    unsigned char buffer[64];
} SHA1_CTX;

#define SHA1_DIGEST_SIZE 20

DLLEXPORT void compute_sha1(const unsigned char *str, size_t len, unsigned char *output);

/* Incremental (streaming) API. Caller owns the context: allocate
   sha1_stream_ctx_size() bytes, then init / update... / final.
   final writes the raw SHA1_DIGEST_SIZE byte digest to output. */
DLLEXPORT size_t sha1_stream_ctx_size(void);
DLLEXPORT void sha1_stream_init(void *ctx);
DLLEXPORT void sha1_stream_update(void *ctx, const unsigned char *data, size_t len);
DLLEXPORT void sha1_stream_final(void *ctx, unsigned char *output);

#ifdef __cplusplus
}
#endif

#endif /* __SHA1_H */
