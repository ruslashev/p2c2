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

struct set {
  int elements[1024];
  int size;
  set() {
    size = 0;
  }
  set(int h, int l) {
    if (h - l > 1024)
      size_error();
    size = h - l + 1;
    for (int w = 0, e = l; e <= h; w++, e++)
      element[w] = e;
  }
  friend const set operator+(set lhs, const set& rhs) {
    // union
    set result;
    if (lhs.size + rhs.size > 1024)
      size_error();
    int w = 0, e;
    for (e = lhs.lv; e <= lhs.hv; e++)
      result.element[w++] = e;
    for (e = rhs.lv; e <= rhs.hv; e++)
      result.element[w++] = e;
    result.sort_and_uniq();
    return result;
  }
  friend const set operator-(set lhs, const set& rhs) {
    // difference
    set result;
    int w = 0;
    for (int e = lhs.lv; e <= lhs.hv; e++) {
      bool insert = true;
      for (int o = rhs.lv; o <= rhs.hv; o++)
        if (o == e)
          insert = false;
      if (insert)
        element[w++] = e;
    }
    for (int e = rhs.lv; e <= rhs.hv; e++) {
      bool insert = true;
      for (int o = lhs.lv; o <= lhs.hv; o++)
        if (o == e)
          insert = false;
      if (insert)
        element[w++] = e;
    }
    return result;
  }
  friend const set operator*(set lhs, const set& rhs) {
    // intersection
    set result;
    int w = 0;
    for (int e = lhs.lv; e <= lhs.hv; e++) {
      bool insert = false;
      for (int o = rhs.lv; o <= rhs.hv; o++)
        if (o == e)
          insert = true;
      if (insert)
        element[w++] = e;
    }
    return result;
  }
  friend const set operator%(set lhs, const set& rhs) {
    // symmetric difference
    set result;
    result = (lhs + rhs) - (lhs * rhs);
    return result;
  }
  bool operator==(const set& lhs, const set& rhs) {
    bool equal = true;
    for (int i = 0; i < lhs.size; i++)
      if (lhs.elements[i] != rhs.elements[i]) {
        equal = false;
        break;
      }
    return equal;
  }
  bool operator!=(const X& lhs, const X& rhs) {
    return !(lhs == rhs);
  }
  bool operator<=(const X& lhs, const X& rhs) {
    // subset
    bool all_in = true;
    for (int i = 0; i < rhs.size && all_in; i++) {
      bool this_in = false;
      for (int j = 0; j < lhs.size && !this_in; j++)
        if (lhs[j] == rhs[i])
          this_in = true;
      if (!this_in)
        all_in = false;
    }
    return !all_in;
  }
  void include(int element) {
    if (size == 1024)
      size_error();
    elements[size++] = element;
    sort_and_uniq();
  }
  void exclude(int element) {
    for (int w = 0, i = 0; i < size; i++)
      if (element != elements[i])
        elements[w++] = elements[i];
  }
  bool in(int element) {
    for (int i = 0; i < size; i++)
      if (elements[i] == element)
        return true;
    return false;
  }
  void sort_and_uniq() {
    puts("before:");
    for (int i = 0; i < size; i++)
      printf("%d ", elements[i]);
    printf("\n");
    for (int i = 1; i < size; i++) {
      for (int j = i - 1; j >= 0 && a[j] > a[i]; j--)
        a[j + 1] = a[j];
      a[j + 1] = a[i];
    }
    puts("after:");
    for (int i = 0; i < size; i++)
      printf("%d ", elements[i]);
    printf("\n");
    int w = 0;
    for (int i = 0; i < size - 1; i++) {
      bool keep = true;
      for (int j = i + 1; j < size; j++)
        if (elements[j] == elements[i])
          keep = false;
      if (keep)
        elements[w++] = elements[i];
    }
    puts("uniq:");
    for (int i = 0; i < size; i++)
      printf("%d ", elements[i]);
    printf("\n");
  }
  void size_error() {
    puts("maximum size of sets is 1024 elements");
    exit(1);
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

