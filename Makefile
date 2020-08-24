# Public Domain
#
# Run `make` to generate the documentation
#
# This makefile assumes that you have the following installed
# * Pandoc, for converting LaTeX to various formats
# * TGIF, for converting vector images in TGIF's file format, and,
# * sed.
#
# All of which are available as Ubuntu and Slackware packages.

DATE = $(shell date +'%d %B %Y')

OUTFILES := index.html index.md
TEMPLATEFILE_HTML := template.html
TEMPLATEFILE_MD := template.md

TGIF_FLAGS := -print -pdf
TGIF_EXT := obj
TGIF_INTERM_EXT := pdf
INKSCAPE := inkscape
INKSCAPE_FLAGS := -z -T -D -l

IMAGE_OUT_EXT := svg
IMAGE_DIR := source-images
IMAGE_OUT_DIR := images

IMAGES := classes_and_c \
          format        \
          libavcodec
OUT_IMAGES := $(addprefix  $(IMAGE_OUT_DIR)/,$(addsuffix .$(IMAGE_OUT_EXT),$(IMAGES)))

.PHONY: all clean

all: $(OUTFILES) $(OUT_IMAGES)

clean:
	rm $(OUTFILES)

%.html: %.tex
	pandoc -s --base-header-level=2 --css main.css --template $(TEMPLATEFILE_HTML) \
	       --metadata date="`date +'%d %B %Y'`" --toc -t html $< > $@

%.md: %.tex
	pandoc -s --css main.css --base-header-level=2 --template $(TEMPLATEFILE_MD) \
	       --metadata date="`date +'%d %B %Y'`" --toc -t markdown $< > $@

$(IMAGE_OUT_DIR)/%.$(IMAGE_OUT_EXT): $(IMAGE_DIR)/%.$(TGIF_EXT)
	tgif $(TGIF_FLAGS) $<
	$(INKSCAPE) $(INKSCAPE_FLAGS) $@ $(<:.$(TGIF_EXT)=.$(TGIF_INTERM_EXT))
	rm $(IMAGE_DIR)/*.$(TGIF_INTERM_EXT)
