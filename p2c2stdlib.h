#include <limits.h>
#include <math.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define maxint INT_MAX
#define minint INT_MIN

typedef float real;

#ifdef __cplusplus
template <int l, int h>
struct subrange {
  int v;
  operator int() { return v; }
  subrange& operator=(const int nv) {
    if (nv >= l && nv <= h)
      v = nv;
    else {
      printf("Error: subrange value %d is out of its bounds\n", nv);
      exit(1);
    }
    return *this;
  }
};

template <int l, int h, class T>
struct array {
  T value[h - l + 1];
  T& operator[](const int i) {
    if (i >= l && i <= h)
      return value[i - l];
    else {
      printf("Error: indexing array out of bounds (%d)\n", i);
      exit(1);
    }
  }
};

struct set {
  int elements[1024];
  int size;
  set() {
    size = 0;
  }
  set(int l, int h) {
    if (h - l > 1024)
      size_error();
    size = h - l + 1;
    for (int w = 0, e = l; e <= h; w++, e++)
      elements[w] = e;
  }
  friend const set operator+(set lhs, const set& rhs) {
    // union
    set result;
    if (lhs.size + rhs.size > 1024)
      result.size_error();
    result.size = lhs.size + rhs.size;
    int w = 0, e;
    for (e = 0; e < lhs.size; e++)
      result.elements[w++] = lhs.elements[e];
    for (e = 0; e < rhs.size; e++)
      result.elements[w++] = rhs.elements[e];
    result.sort_and_uniq();
    return result;
  }
  friend const set operator+(set lhs, const int& rhs) {
    // union
    set result;
    if (lhs.size + 1 > 1024)
      result.size_error();
    result.size = lhs.size + 1;
    int w = 0, e;
    for (e = 0; e < lhs.size; e++)
      result.elements[w++] = lhs.elements[e];
    result.elements[w++] = rhs;
    result.sort_and_uniq();
    return result;
  }
  friend const set operator-(set lhs, const set& rhs) {
    // difference
    set result;
    int w = 0;
    for (int e = 0; e < lhs.size; e++) {
      bool insert = true;
      for (int o = 0; o < rhs.size; o++)
        if (rhs.elements[o] == lhs.elements[e])
          insert = false;
      if (insert) {
        result.elements[w++] = lhs.elements[e];
        result.size++;
      }
    }
    return result;
  }
  friend const set operator*(set lhs, const set& rhs) {
    // intersection
    set result;
    int w = 0;
    for (int e = 0; e < lhs.size; e++) {
      bool insert = false;
      for (int o = 0; o < rhs.size; o++)
        if (rhs.elements[o] == lhs.elements[e])
          insert = true;
      if (insert) {
        result.elements[w++] = lhs.elements[e];
        result.size++;
      }
    }
    return result;
  }
  friend const set operator%(set lhs, const set& rhs) {
    // symmetric difference
    set result;
    result = (lhs + rhs) - (lhs * rhs);
    return result;
  }
  friend bool operator==(const set& lhs, const set& rhs) {
    bool equal = true;
    for (int i = 0; i < lhs.size; i++)
      if (lhs.elements[i] != rhs.elements[i]) {
        equal = false;
        break;
      }
    return equal;
  }
  friend bool operator!=(const set& lhs, const set& rhs) {
    return !(lhs == rhs);
  }
  friend bool operator<=(const set& lhs, const set& rhs) {
    // subset
    bool all_in = true;
    for (int i = 0; i < rhs.size && all_in; i++) {
      bool this_in = false;
      for (int j = 0; j < lhs.size && !this_in; j++)
        if (lhs.elements[j] == rhs.elements[i])
          this_in = true;
      if (!this_in)
        all_in = false;
    }
    return all_in;
  }
  void include(int element) {
    if (size == 1024)
      size_error();
    elements[size++] = element;
    sort_and_uniq();
  }
  void exclude(int element) {
    int w = 0, i = 0;
    for (; i < size; i++)
      if (element != elements[i])
        elements[w++] = elements[i];
    size = w;
  }
  friend bool operator&(set lhs, const int& element) {
    // in
    for (int i = 0; i < lhs.size; i++)
      if (lhs.elements[i] == element)
        return true;
    return false;
  }
  void print() {
    for (int i = 0; i < size; i++)
      printf("%d ", elements[i]);
    printf("\n");
  }
  void sort_and_uniq() {
    int j, value;
    for (int i = 1 ; i < size ; i++) {
        value = elements[i];
        for (j = i - 1; j >= 0 && elements[j] > value; j--)
            elements[j + 1] = elements[j];
        elements[j + 1] = value;
    }
    int w = 1;
    for (int i = 1; i < size; i++) {
      bool keep = true;
      for (int j = i - 1; j >= 0; j--)
        if (elements[j] == elements[i])
          keep = false;
      if (keep)
        elements[w++] = elements[i];
    }
    size = w;
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
    data = 0;
  }
  ~string() {
    delete [] data;
  }
  string(const char *str) {
    length = strlen(str);
    data = new char[length + 1];
    strncpy(data, str, length);
  }
  string(const string& str) {
    length = strlen(str.data);
    data = new char[length + 1];
    strncpy(data, str.data, length);
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
  friend bool operator==(const string& lhs, const string& rhs) {
    return (strcmp(lhs.data, rhs.data) == 0);
  }
  friend bool operator!=(const string& lhs, const string& rhs) {
    return !(lhs == rhs);
  }
  char* c_str() {
    return data;
  }
  friend void readstr(string &str) {
    char buffer[3 * 1024];
    fgets(buffer, 3 * 1024, stdin);
    buffer[str.length - 1] = 0;
    delete [] str.data;
    str.length = strlen(buffer);
    str.data = new char[str.length + 1];
    strncpy(str.data, buffer, str.length);
  }
};

#endif

double sqr(double x) {
  return x * x;
}

double ln(double x) {
  return log(x);
}

double arctan(double x) {
  return atan(x);
}

double trunc(double x) {
  return floor(x);
}

int ord(char x) {
  return x;
}

char chr(int x) {
  return x;
}

int succ(int x) {
  return x + 1;
}

bool odd(int x) {
  return (abs(x) % 2) == 1;
}

#define eof (feof(stdin))

void write(int n, ...) {
  va_list args;
  va_start(args, n);
  for (int i = 0; i < n; i++)
    printf("%s", va_arg(args, char*));
  va_end(args);
}

void writeln(int n, ...) {
  va_list args;
  va_start(args, n);
  for (int i = 0; i < n; i++)
    printf("%s", va_arg(args, char*));
  va_end(args);
  printf("\n");
}

char* width_format(double x, int w) {
  char b[256];
  if (fabs(x - floor(x)) < 0.0001)
    sprintf(b, "%*d", w, (int)x);
  else
    sprintf(b, "%*f", w, x);
  return strdup(b);
}

char* full_format(double x, int w, int p) {
  char b[256];
  sprintf(b, "%*.*f", w, p, x);
  return strdup(b);
}

void readi(int &x) {
  scanf("%d", &x);
}

void reads(string &x) {
  char b[256];
  scanf("%d", b);
  x = b;
}

void readf(double &x) {
  scanf("%f", &x);
}

char* inttostr(int x) {
  char b[256];
  sprintf("%d", x);
  return strdup(b);
}

char* ftostr(double x) {
  char b[256];
  sprintf("%f", x);
  return strdup(b);
}

void new(void &x) {
  malloc(x, sizeof(x));
}

void dispose(void &x) {
  free(x);
}

