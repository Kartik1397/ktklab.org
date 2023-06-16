UID := $(shell id -u)

SOURCE_DOCS := $(wildcard src/*md)
SOURCE_CSS := css/pandoc.css
SOURCE_IMAGES := $(wildcard images/*)

EXPORTED_DOCS := $(addprefix html/,$(notdir $(SOURCE_DOCS:.md=.html)))
EXPORTED_CSS := $(addprefix html/css/,$(notdir $(SOURCE_CSS)))
EXPORTED_IMAGES := $(addprefix html/images/,$(notdir $(SOURCE_IMAGES)))

PANDOC := docker run --rm -v $(shell pwd):/data --user $(UID) pandoc/core:3.1.1
PANDOC_OPTIONS := -t markdown-smart --standalone
PANDOC_HTML_OPTIONS := --to html5 --css $(SOURCE_CSS)

html/%.html : src/%.md $(EXPORTED_CSS) $(EXPORTED_IMAGES) Makefile
	$(PANDOC) $(PANDOC_OPTIONS) $(PANDOC_HTML_OPTIONS) $< -o $@

html/css/%.css: css/%.css Makefile
	cp $< $@

html/images/%.webp: images/%.webp Makefile
	cp $< $@

.PHONY: all clean

all: $(EXPORTED_DOCS) $(EXPORTED_CSS) $(EXPORTED_IMAGES)

clean:
	rm -f html/*.html
	rm -f html/css/*.css
	rm -f html/images/*.webp

