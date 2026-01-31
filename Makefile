# Allow JAVA_HOME to be overridden by environment variable
JAVA_HOME ?= /nix/store/gi1zpnpwayp2qc1k6l4zvk10d934wy3s-openjdk-25.0.1+8/lib/openjdk
#in bash use     dirname $(dirname $(readlink -f $(which javac))) to find where it is
# Basic check to see if JAVA_HOME is valid
ifeq ($(wildcard $(JAVA_HOME)/include/linux/jni_md.h),)
    $(warning JAVA_HOME ($(JAVA_HOME)) does not appear to contain include/linux/jni_md.h. Build may fail.)
endif

CC ?= clang
# (optional) CFLAGS ?= -g -Wall

INCLUDES = -I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/linux
LIBS = -ljvm -L $(JAVA_HOME)/lib -L $(JAVA_HOME)/lib/server

TARGET_DIR = src/dummy_godot_project
TARGET = $(TARGET_DIR)/entry.so

CC ?= clang
CFLAGS ?= -g -Wall -fPIC
CPPFLAGS ?= $(INCLUDES)
LDFLAGS ?= -Wl,--no-as-needed -rdynamic -L$(JAVA_HOME)/lib -L$(JAVA_HOME)/lib/server
LDLIBS ?= -ljvm

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
