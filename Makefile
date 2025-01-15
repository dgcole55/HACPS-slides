# Directories
SRC_DIR := source
OUT_DIR := build
FIGURE_DIR := $(SRC_DIR)/images

# Pattern to ignore
IGNORE_PATTERN := $(SRC_DIR)/**/notes.md

# Find all Markdown files and exclude those matching the ignore pattern
ALL_SRC_FILES := $(wildcard $(SRC_DIR)/**/*.md)
SRC_FILES := $(filter-out $(wildcard $(IGNORE_PATTERN)), $(ALL_SRC_FILES))
OUT_FILES := $(patsubst $(SRC_DIR)/%.md, $(OUT_DIR)/%.pdf, $(SRC_FILES))

# Default rule
all: $(OUT_FILES)

# Rule to preprocess and convert Markdown to PDF
$(OUT_DIR)/%.pdf: $(SRC_DIR)/%.md
	@echo "$<"
	@mkdir -p $(dir $@) # Ensure output directory exists
	@sed 's|{{FIGURE_DIR}}|$(FIGURE_DIR)|g' $< > $<.tmp # Replace FIGURE_DIR placeholder
	@pandoc $<.tmp -o $@ -f markdown -t beamer
	@rm $<.tmp # Clean up temporary file

# Clean generated PDFs
clean:
	rm -rf $(OUT_DIR)

# Debug
print:
	@echo "SRC_FILES: $(SRC_FILES)"
	@echo "OUT_FILES: $(OUT_FILES)"
	@echo "FIGURE_DIR: $(FIGURE_DIR)"

touch: 
	@for file in $(SRC_FILES); do \
		echo "Touching $$file"; \
		touch $$file; \
	done

open:
	open $(OUT_FILES)