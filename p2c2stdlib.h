#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define maxint INT_MAX
#define minint INT_MIN

typedef float real;

#ifdef __cplusplus
template <int l, int h>
struct subrange {
  int v;
  subrange() {} // TODO
  operator int() { return v; }
  subrange& operator=(const int nv) {
    (nv >= l && nv <= h) ? (v = nv) :
      printf("Error: subrange value %d is out of its bounds\n", v);
    return *this;
  }
};

template <int l, int h, class T>
struct array {
  T value[h - l + 1];
  T& operator[](const int i) {
    return (i >= l && i <= h)
      ? value[i - l]
      : printf("Error: indexing array out of bounds (%d)\n", i);
  }
};

struct string
{
  char* data;
  size_t length;
  string() {
    data = nullptr;
  }
  ~string() {
    delete [] data;
  }
  string(const char *str) {
    length = strlen(str);
    data = new char[length + 1];
    strncpy(data, str, length);
  }
  string(const string& str) : string(str.data) { }
  void swap(string& other) {
    std::swap(other.data, data);
  }
  string& operator=(const char *str) {
    delete [] data;
    length = strlen(str);
    data = new char[length + 1];
    strncpy(data, str, length);
    return *this;
  }
  string& operator=(string other) {
    delete [] data;
    length = other.length;
    data = new char[length + 1];
    strncpy(data, other.data, length);
    return *this;
  }
  friend const string operator+(string lhs, const string& rhs) {
    string result;
    result.length = lhs.length + rhs.length;
    result.data = new char[result.length + 1];
    strcpy(result.data, lhs.data);
    strcat(result.data, rhs.data);
    return result;
  }
  char* c_str() {
    return data;
  }
};

#endif

