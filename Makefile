# Public Domain

OUTFILE := index.html

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
	rm $(IMAGE_OUT_DIR)/*.$(IMAGE_OUT_FORMAT)
	rm $(OUTFILE)

%.html: %.md
	markdown $< > $@

$(IMAGE_OUT_DIR)/%.$(IMAGE_OUT_EXT): $(IMAGE_DIR)/%.$(TGIF_EXT)
	tgif $(TGIF_FLAGS) $<
	$(INKSCAPE) $(INKSCAPE_FLAGS) $@ $(<:.$(TGIF_EXT)=.$(TGIF_INTERM_EXT))
	rm $(IMAGE_DIR)/*.$(TGIF_INTERM_EXT)
