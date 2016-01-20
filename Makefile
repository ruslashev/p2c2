OBJS = .lexer.o .parser.o .main.o
CXX = g++
CXXFLAGS = -Wall -Wextra -g -std=c++0x
EXECNAME = p2c2

all:
	bison -v -d -o parser.cc parser.y -Wno-other
	flex -o lexer.cc lexer.l
	$(CXX) -c -o .parser.o parser.cc $(CXXFLAGS)
	$(CXX) -c -o .lexer.o lexer.cc $(CXXFLAGS)
	$(CXX) -c -o .main.o main.cc $(CXXFLAGS)
	$(CXX) -o p2c2 .lexer.o .parser.o .main.o

clean:
	rm -f $(EXECNAME)
	rm -f $(OBJS)

test: all
	@echo "bubble.pas ===================================================================="
	./p2c2 bubble.pas
	@echo "quicksort.pas ================================================================="
	./p2c2 quicksort.pas
	@echo "tri.pas ======================================================================="
	./p2c2 tri.pas

vi:
	vim lexer.l parser.y parser.output *.pas -p

