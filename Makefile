UID := $(shell id -u)

SOURCE_DOCS := $(wildcard src/*md)
SOURCE_CSS := css/pandoc.css

EXPORTED_DOCS := $(addprefix html/,$(notdir $(SOURCE_DOCS:.md=.html)))
EXPORTED_CSS := $(addprefix html/css/,$(notdir $(SOURCE_CSS)))

PANDOC := docker run --rm -v $(shell pwd):/data --user $(UID) pandoc/core:3.1.1
PANDOC_OPTIONS := -t markdown-smart --standalone
PANDOC_HTML_OPTIONS := --to html5 --css $(SOURCE_CSS)

html/%.html : src/%.md $(EXPORTED_CSS) Makefile
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_HTML_OPTIONS) $< -o $@

html/css/%.css: css/%.css Makefile
	cp $< $@

.PHONY: all clean

all: $(EXPORTED_DOCS) $(EXPORTED_CSS)

clean:
	rm -f html/*.html
	rm -f html/css/*.css

