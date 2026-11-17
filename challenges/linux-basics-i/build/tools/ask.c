/*
 * Theory quiz binary. Built with generated ask_data.h providing:
 *   N_QUESTIONS, Q_TEXTS[], A_HASHES[] (sha256 of normalized answers),
 *   FLAG_XOR_HEX / FLAG_LEN (XOR with sha256 of pipe-joined normalized answers).
 * Mode 111 execute-only after install.
 */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/sha.h>
#include "ask_data.h"

static void normalize(const char *in, char *out, size_t out_sz) {
  size_t i = 0, j = 0;
  while (in[i] && isspace((unsigned char)in[i])) i++;
  while (in[i] && j + 1 < out_sz) {
    out[j++] = (char)tolower((unsigned char)in[i++]);
  }
  while (j > 0 && isspace((unsigned char)out[j - 1])) j--;
  out[j] = '\0';
}

static void sha256_hex(const char *s, char out[65]) {
  unsigned char dig[SHA256_DIGEST_LENGTH];
  SHA256((const unsigned char *)s, strlen(s), dig);
  for (int i = 0; i < SHA256_DIGEST_LENGTH; i++)
    sprintf(out + i * 2, "%02x", dig[i]);
  out[64] = '\0';
}

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

int main(void) {
  char line[512];
  char norm[512];
  char collected[4096];
  collected[0] = '\0';

  puts("");
  puts("=== Theory quiz ===");
  puts("Answer each prompt. Spelling matters; case does not.");
  puts("Type q to abort.");
  puts("");

  for (int i = 0; i < N_QUESTIONS; i++) {
    for (;;) {
      printf("Q%d) %s\n> ", i + 1, Q_TEXTS[i]);
      if (!fgets(line, sizeof line, stdin)) return 1;
      size_t n = strlen(line);
      while (n > 0 && (line[n - 1] == '\n' || line[n - 1] == '\r'))
        line[--n] = '\0';
      if (strcmp(line, "q") == 0 || strcmp(line, "Q") == 0) {
        puts("Aborted.");
        return 1;
      }
      normalize(line, norm, sizeof norm);
      char got[65];
      sha256_hex(norm, got);
      if (strcmp(got, A_HASHES[i]) != 0) {
        puts("Not quite. Try again (or q to quit).");
        continue;
      }
      puts("Correct.");
      puts("");
      if (collected[0]) strncat(collected, "|", sizeof(collected) - strlen(collected) - 1);
      strncat(collected, norm, sizeof(collected) - strlen(collected) - 1);
      break;
    }
  }

  unsigned char key[SHA256_DIGEST_LENGTH];
  SHA256((const unsigned char *)collected, strlen(collected), key);

  unsigned char xored[FLAG_LEN];
  if (hex_to_bytes(FLAG_XOR_HEX, xored, FLAG_LEN) != 0) {
    fprintf(stderr, "ask corrupt\n");
    return 1;
  }

  puts("All answers accepted.");
  fputs("FLAG: ", stdout);
  for (int i = 0; i < FLAG_LEN; i++)
    putchar((char)(xored[i] ^ key[i % SHA256_DIGEST_LENGTH]));
  putchar('\n');
  return 0;
}
