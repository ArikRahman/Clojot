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

# entry.so maker might have more flags than needed but I did not want to risk breaking
# anything so it stays the way it is
all:
	$(CC) -g -Wall -Wl,--no-as-needed -fPIC $(INCLUDES) -c src/entry.c -o entry.o -rdynamic $(LIBS)
	$(CC) -g -fPIC -Wl,--no-as-needed $(INCLUDES) $(LIBS) -shared -o $(TARGET) entry.o -rdynamic
	rm entry.o

clean:
	rm -f $(TARGET) entry.o
