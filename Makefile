#
EXECUTABLE = program
# コンパイラとフラグ
CC = gcc

CFLAGS_ALL	 = -std=gnu2x -Wall -Wextra -Wunused -fanalyzer
CFLAGS_ALL	+= -finput-charset=UTF-8 -fexec-charset=CP932 -fwide-exec-charset=utf-16le
# CFLAGS_ALL	+=

# フラグのセットを定義
CFLAGS_DEBUG = -g3 -Og
CFLAGS_RELEASE = -O2

LDFLAGS = -lm

# フォルダ設定
SRC_DIR = src
BUILD_DIR = build
SOURCES = $(SRC_DIR)/main.c
OBJECTS = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SOURCES))

# ターゲット設定
all: debug

debug: CFLAGS = $(CFLAGS_ALL) $(CFLAGS_DEBUG)
debug: $(EXECUTABLE)

release: CFLAGS = $(CFLAGS_ALL) $(CFLAGS_RELEASE)
release: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

# オブジェクトファイルをbuildフォルダに保存
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir $(BUILD_DIR)
	@$(CC) $(CFLAGS) $(LDFLAGS) -c -o $@ $<

# 実行
run: $(EXECUTABLE)
	@./$(EXECUTABLE)

# デバッグ開始
debug_run: debug
	gdb ./$(EXECUTABLE)

# clang-formatの適用
format:
	@clang-format -i $(SOURCES)
	@echo "Code formatted with clang-format."

# クリーンアップ
clean:
	rm -rf $(BUILD_DIR) $(EXECUTABLE)

# バージョン情報を表示
version:
	@gcc --version
	@gdb --version
	@cmake --version
# @make --version
	@clang-format --version

# ヘルプ表示
help:
	@echo "Makefile Usage:"
	@echo "  make all        - Build debug version"
	@echo "  make release    - Build release version"
	@echo "  make run        - Run the program"
	@echo "  make debug_run  - Debug the program with gdb"
	@echo "  make format     - Format code with clang-format"
	@echo "  make clean      - Clean build files"
	@echo "  make version    - Show versions of gcc, gdb, and clang-format"
	@echo "  make help       - Show this help message"

.PHONY: all debug release run debug_run clean format version help
