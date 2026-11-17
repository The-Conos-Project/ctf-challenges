/*
 * Per-station checker. Built with:
 *   -DEXPECTED_HASH=\"<sha256 hex of keyword>\"
 *   -DFLAG_XOR_HEX=\"<flag bytes XOR sha256(keyword), as hex>\"
 *   -DFLAG_LEN=<n>
 * Linked with -lcrypto. Installed mode 111 (execute-only) so students
 * can run it but cannot cat/strings the binary.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/sha.h>

#ifndef EXPECTED_HASH
#error EXPECTED_HASH required
#endif
#ifndef FLAG_XOR_HEX
#error FLAG_XOR_HEX required
#endif
#ifndef FLAG_LEN
#error FLAG_LEN required
#endif

static int hex_nibble(char c) {
  if (c >= '0' && c <= '9') return c - '0';
  if (c >= 'a' && c <= 'f') return c - 'a' + 10;
  if (c >= 'A' && c <= 'F') return c - 'A' + 10;
  return -1;
}

static int hex_to_bytes(const char *hex, unsigned char *out, int out_len) {
  int n = (int)strlen(hex);
  if (n != out_len * 2) return -1;
  for (int i = 0; i < out_len; i++) {
    int hi = hex_nibble(hex[i * 2]);
    int lo = hex_nibble(hex[i * 2 + 1]);
    if (hi < 0 || lo < 0) return -1;
    out[i] = (unsigned char)((hi << 4) | lo);
  }
  return 0;
}

static void sha256_hex(const char *s, char out[65]) {
  unsigned char dig[SHA256_DIGEST_LENGTH];
  SHA256((const unsigned char *)s, strlen(s), dig);
  for (int i = 0; i < SHA256_DIGEST_LENGTH; i++)
    sprintf(out + i * 2, "%02x", dig[i]);
  out[64] = '\0';
}

int main(int argc, char **argv) {
  if (argc < 2) {
    fprintf(stderr, "Usage: ./checker <keyword>\n");
    return 1;
  }

  char got[65];
  sha256_hex(argv[1], got);
  if (strcmp(got, EXPECTED_HASH) != 0) {
    puts("Wrong keyword. Keep looking.");
    return 1;
  }

  unsigned char key[SHA256_DIGEST_LENGTH];
  SHA256((const unsigned char *)argv[1], strlen(argv[1]), key);

  unsigned char xored[FLAG_LEN];
  if (hex_to_bytes(FLAG_XOR_HEX, xored, FLAG_LEN) != 0) {
    fprintf(stderr, "checker corrupt\n");
    return 1;
  }

  for (int i = 0; i < FLAG_LEN; i++)
    putchar((char)(xored[i] ^ key[i % SHA256_DIGEST_LENGTH]));
  putchar('\n');
  return 0;
}
