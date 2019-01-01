CFLAGS = -Wall -O2

all: hello

hello: hello.o
	$(CC) $(LDFLAGS) -o hello hello.o

test: hello
	./hello

clean:
	$(RM) hello hello.o
