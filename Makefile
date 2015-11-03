OBJS = $(patsubst ./%.cc,./.%.o, $(shell find . -type f -name '*.cc'))
CXX = g++
CXXFLAGS = -Wall -Wextra -Werror -g -std=c++0x
EXECNAME = p2c2

all: $(EXECNAME)
	./$(EXECNAME)

./.%.o: %.cc
	@echo "Compiling $<"
	@$(CXX) -c -o $@ $< $(CXXFLAGS)

$(EXECNAME): $(OBJS)
	@echo "Linking to $@"
	@$(CXX) -o $@ $^

clean:
	rm -f $(EXECNAME)
	rm -f $(OBJS)

