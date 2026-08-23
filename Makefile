# Local LaTeX build, configured to mirror Overleaf's compile.
#
# Overleaf runs:  latexmk -cd -f -pdf -synctex=1 -file-line-error <main.tex>
# from the project root, with the project root on TEXINPUTS. The -cd makes
# paths like \input{math_commands.tex} resolve next to the main file, while
# TEXINPUTS makes project-root-relative paths like \input{iclr2027/pdcm_theory}
# resolve too. Both forms are used in this document, so keep both.

ROOT := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
MAIN := iclr2027/iclr2027_conference.tex
OUT  := build

export TEXINPUTS := $(ROOT):
export BIBINPUTS := $(ROOT):
export BSTINPUTS := $(ROOT):

LATEXMK := latexmk -cd -f -pdf -synctex=1 -file-line-error \
	-interaction=nonstopmode -outdir=$(ROOT)/$(OUT)

.PHONY: all watch clean distclean

all:
	$(LATEXMK) $(MAIN)
	@echo "PDF: $(OUT)/$(notdir $(MAIN:.tex=.pdf))"

# Rebuild on save.
watch:
	$(LATEXMK) -pvc $(MAIN)

# Drop aux files, keep the PDF.
clean:
	$(LATEXMK) -c $(MAIN)

# Drop everything, PDF included.
distclean:
	$(LATEXMK) -C $(MAIN)
	rm -rf $(OUT)
