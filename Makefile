OBJS = .lexer.o .parser.o .main.o .ast.o .utils.o .codegen.o
CXX = g++
CXXFLAGS = -Wall -Wextra -Wpedantic -g -std=c++0x
EXECNAME = p2c2

all:
	bison -v -d -o parser.cc parser.y -Wno-other
	flex -o lexer.cc lexer.l
	$(CXX) -c -o .lexer.o lexer.cc $(CXXFLAGS)
	$(CXX) -c -o .parser.o parser.cc $(CXXFLAGS)
	$(CXX) -c -o .main.o main.cc $(CXXFLAGS)
	$(CXX) -c -o .ast.o ast.cc $(CXXFLAGS)
	$(CXX) -c -o .utils.o utils.cc $(CXXFLAGS)
	$(CXX) -c -o .codegen.o codegen.cc $(CXXFLAGS)
	$(CXX) -o p2c2 $(OBJS)

clean:
	rm -f $(EXECNAME)
	rm -f $(OBJS)

vi:
	vim lexer.l parser.y codegen.cc main.cc ast.cc utils.cc -p

lines:
	wc -l ast.* codegen.* lexer.l main.cc Makefile parser.y test.sh utils.*

