OBJS = .lexer.o .parser.o .main.o .ast.o
CXX = g++
CXXFLAGS = -Wall -Wextra -g -std=c++0x
EXECNAME = p2c2

all:
	bison -v -d -o parser.cc parser.y -Wno-other
	flex -o lexer.cc lexer.l
	$(CXX) -c -o .parser.o parser.cc $(CXXFLAGS)
	$(CXX) -c -o .lexer.o lexer.cc $(CXXFLAGS)
	$(CXX) -c -o .ast.o ast.cc $(CXXFLAGS)
	$(CXX) -c -o .main.o main.cc $(CXXFLAGS)
	$(CXX) -o p2c2 $(OBJS)

clean:
	rm -f $(EXECNAME)
	rm -f $(OBJS)

vi:
	vim lexer.l parser.y parser.output main.cc ast.cc -p

