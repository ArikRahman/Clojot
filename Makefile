# Allow JAVA_HOME to be overridden by environment variable.
# Point this at the JDK root (the directory that contains include/ and lib/).
JAVA_HOME ?= /nix/store/gi1zpnpwayp2qc1k6l4zvk10d934wy3s-openjdk-25.0.1+8/lib/openjdk
#in bash use     dirname $(dirname $(readlink -f $(which javac))) to find where it is

CC ?= clang
CFLAGS ?= -g -Wall -fPIC

CPPFLAGS += -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux

# Where libjvm.so lives for OpenJDK (commonly lib/server)
JVM_LIBDIR ?= $(JAVA_HOME)/lib/server

# Linker search path first, then the library.
LDFLAGS += -Wl,--no-as-needed -rdynamic -L$(JVM_LIBDIR) -Wl,-rpath,$(JVM_LIBDIR)
LDLIBS  += -ljvm

TARGET_DIR = src/dummy_godot_project
TARGET     = $(TARGET_DIR)/entry.so

.PHONY: all clean

all: $(TARGET)

entry.o: src/entry.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(TARGET): entry.o
	mkdir -p $(TARGET_DIR)
	$(CC) -shared -o $@ $^ $(LDFLAGS) $(LDLIBS)
	rm -f entry.o

clean:
	rm -f $(TARGET) entry.o
