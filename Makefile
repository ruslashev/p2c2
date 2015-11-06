OBJS = .lexer.o .parser.o .main.o
CXX = g++
CXXFLAGS = -Wall -Wextra -g -std=c++0x
EXECNAME = p2c2

all:
	bison -d -o parser.cc parser.y
	flex -o lexer.cc lexer.l
	$(CXX) -c -o .parser.o parser.cc $(CXXFLAGS)
	$(CXX) -c -o .lexer.o lexer.cc $(CXXFLAGS)
	$(CXX) -c -o .main.o main.cc $(CXXFLAGS)
	$(CXX) -o p2c2 .lexer.o .parser.o .main.o
	./p2c2

clean:
	rm -f $(EXECNAME)
	rm -f $(OBJS)

