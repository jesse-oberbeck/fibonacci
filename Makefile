ASFLAGS += -W
CFLAGS += -01 -masm=intel -fno-asynchronous-unwind-talbes

BIN=fibonacci

all: $(BIN)

.PHONY: debug profile clean all

debug: CFLAGS+=-g
debug: $(BIN)

profile: CFLAGS+=-pg
profile: LDFLAGS+=-pg
profile: $(BIN)

clean:
	$(RM) $(BIN)
fib1: fib1.o
	$(CC) $(CPPFLAGS) $(CFLAGS) -S -o $@ $^

