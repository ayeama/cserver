CC := gcc
CFLAGS := -std=c23 -Wall -Wextra

SRC_DIR := src
LIBS_DIR := libs
BUILD_DIR := build

LIB_INCLUDE_DIRS := $(wildcard $(LIBS_DIR)/*/include)
LIB_INCLUDES := $(foreach dir,$(LIB_INCLUDE_DIRS),-I$(dir))
CFLAGS += $(LIB_INCLUDES)

LIB_SRC := $(wildcard $(LIBS_DIR)/*/src/*.c)
APP_SRC := $(wildcard $(SRC_DIR)/*.c)

SERVER_BIN := $(BUILD_DIR)/server
CLIENT_BIN := $(BUILD_DIR)/client

.PHONY: all run format clean

all: $(SERVER_BIN) $(CLIENT_BIN)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(SERVER_BIN): $(SRC_DIR)/server.c $(LIB_SRC) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $^

$(CLIENT_BIN): $(SRC_DIR)/client.c $(LIB_SRC) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -o $@ $^

run:
	./$(BUILD_DIR)/server

format:
	clang-format -i $(SRC_DIR)/*.c

clean:
	rm -rf $(BUILD_DIR)
