# Public Domain
#
# Run `make` to generate the documentation
#
# This makefile assumes that you have the following installed
# * A script named markdown that takes a markdown file as an argument, and
#   outputs the converted HTML to stdout,
# * TGIF, for converting vector images in TGIF's file format, and,
# * sed.
#
# All of which are available as Ubuntu and Slackware packages.


OUTFILE := index.html
TEMPLATEFILE := template.html

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

all: $(OUTFILE) $(OUT_IMAGES)

clean:
	rm $(OUTFILE)

%.html: %.md
	sed -e '/CONTENT/{e markdown $<' -e 'd}' $(TEMPLATEFILE) | \
	sed -e "s/{{TODAY}}/$(shell date +'%d %B %Y')/g" > $@

$(IMAGE_OUT_DIR)/%.$(IMAGE_OUT_EXT): $(IMAGE_DIR)/%.$(TGIF_EXT)
	tgif $(TGIF_FLAGS) $<
	$(INKSCAPE) $(INKSCAPE_FLAGS) $@ $(<:.$(TGIF_EXT)=.$(TGIF_INTERM_EXT))
	rm $(IMAGE_DIR)/*.$(TGIF_INTERM_EXT)
