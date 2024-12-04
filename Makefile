# stm8flash makefile
#
# Multiplatform support
#   - Linux (x86, Raspian)
#   - MacOS (Darwin)
#   - Windows (e.g. mingw-w64-x86 with libusb1.0)


PLATFORM=$(shell uname -s)

# Pass RELEASE=anything to build without debug symbols

	BASE_CFLAGS := -O1


# Pass LIBUSB_QUIET=anything to Make to silence debug output from libusb.

	BASE_CFLAGS += -DSTM8FLASH_LIBUSB_QUIET


BASE_CFLAGS += --std=gnu99 --pedantic -Wall


# 	Generic case is Windows

	LIBS   = usb/static/libusb-1.0.a
	LIBUSB_CFLAGS =
	CC	   = GCC
	BIN_SUFFIX =.exe


# Respect user-supplied cflags, if any - just put ours in front.
override CFLAGS := $(BASE_CFLAGS) $(LIBUSB_CFLAGS) $(CFLAGS)

# Check if install DESTDIR is undefined
ifndef DESTDIR
	DESTDIR=/c/tools/stm8flash
endif

BIN 		=stm8flash
OBJECTS 	=stlink.o stlinkv2.o main.o byte_utils.o ihex.o srec.o stm8.o 


.PHONY: all clean install

$(BIN)$(BIN_SUFFIX): $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) $(LIBS) -o $(BIN)$(BIN_SUFFIX)

all: $(BIN)$(BIN_SUFFIX)

$(OBJECTS): $(wildcard *.h)

libespstlink.so: libespstlink.c libespstlink.h
	$(CC) -shared $(CFLAGS) -fPIC $< -o $@

clean:
	-rm -f $(OBJECTS) $(BIN)$(BIN_SUFFIX)

install:
	mkdir -p $(DESTDIR)/bin/
	cp ./libusb-1.0.dll $(DESTDIR)/bin/
	cp ./README.md $(DESTDIR)/bin/
	cp ./$(BIN)$(BIN_SUFFIX) $(DESTDIR)/bin/

