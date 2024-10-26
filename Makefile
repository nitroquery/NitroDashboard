DIST_DIR := ./dist
BUILD_DIR := $(DIST_DIR)/NitroDashboard
ZIP_FILE := $(DIST_DIR)/NitroDashboard.zip
OP_FILE := $(DIST_DIR)/NitroDashboard.op
SRC_DIR := ./src
AS_FILES := $(shell find $(SRC_DIR) -type f -name "*.as")
ROOT_FILES := LICENSE README.md info.toml NitroDashboardPlugin.as Settings.as

.PHONY: all clean prepare build package

all: clean prepare build package

clean:
	@echo "Cleaning up $(DIST_DIR)..."
	rm -rf $(DIST_DIR)

prepare:
	@echo "Preparing directories..."
	mkdir -p $(BUILD_DIR)

build: prepare
	@echo "Copying root files..."
	cp $(ROOT_FILES) $(BUILD_DIR)
	@echo "Copying assets directory..."
	cp -r assets $(BUILD_DIR)
	@echo "Copying .as files from src directory..."
	$(foreach file, $(AS_FILES), \
		mkdir -p $(BUILD_DIR)/$(dir $(file)); \
		cp $(file) $(BUILD_DIR)/$(file);)

package: build
	@echo "Packaging..."
	cd $(BUILD_DIR) && zip -r ../NitroDashboard.zip .
	@echo "Renaming zip to .op..."
	mv $(ZIP_FILE) $(OP_FILE)
