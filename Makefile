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

OUTFILES          := index.html index.md
TEMPLATEFILE_HTML := template.html
TEMPLATEFILE_MD   := template.md

PANDOC       := pandoc
PANDOC_FLAGS  = -s --toc --css main.css \
                --metadata date="`date +'%d %B %Y'`"

# You may want to uncomment the following line if you are using a newer version
# of pandoc
#
# PANDOC_EXTRA_FLAGS = --shift-heading-level-by=1
PANDOC_EXTRA_FLAGS = --base-header-level=2

TGIF_FLAGS      := -print -pdf
TGIF_EXT        := obj
TGIF_INTERM_EXT := pdf
INKSCAPE        := inkscape
INKSCAPE_FLAGS  := -z -T -D -l

IMAGE_OUT_EXT := svg
IMAGE_DIR     := source-images
IMAGE_OUT_DIR := images

IMAGES     := classes_and_c \
              format        \
              libavcodec
OUT_IMAGES := $(addprefix  $(IMAGE_OUT_DIR)/,$(addsuffix .$(IMAGE_OUT_EXT),$(IMAGES)))

.PHONY: all clean

all: $(OUTFILES) $(OUT_IMAGES)

clean:
	rm $(OUTFILES)

%.html: %.tex $(TEMPLATEFILE_HTML)
	sed "s/\\includesvg/\\includegraphics/g" $< |   \
	$(PANDOC) $(PANDOC_FLAGS) $(PANDOC_EXTRA_FLAGS) \
	          --template $(TEMPLATEFILE_HTML) -f latex -t html > $@

%.md: %.tex $(TEMPLATEFILE_MD)
	sed "s/\\includesvg/\\includegraphics/g" $< |   \
	$(PANDOC) $(PANDOC_FLAGS) $(PANDOC_EXTRA_FLAGS) \
	          --template $(TEMPLATEFILE_MD) -f latex -t markdown > $@

$(IMAGE_OUT_DIR)/%.$(IMAGE_OUT_EXT): $(IMAGE_DIR)/%.$(TGIF_EXT)
	tgif $(TGIF_FLAGS) $<
	$(INKSCAPE) $(INKSCAPE_FLAGS) $@ $(<:.$(TGIF_EXT)=.$(TGIF_INTERM_EXT))
	rm $(IMAGE_DIR)/*.$(TGIF_INTERM_EXT)
