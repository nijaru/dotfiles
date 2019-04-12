CC=g++
CFLAGS=-Wall -Wextra -std=c++14 -march=native -O2 -pipe
SOURCES=$(wildcard src/*.cc)
OBJECTS=$(SOURCES:.cc=.o)
EXECUTABLE=main

$(EXECUTABLE): $(OBJECTS)
	$(CC) $< -o $@

%.o: %.cc
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) $(OBJECTS)
	$(RM) $(EXECUTABLE)

.PHONY: clean
