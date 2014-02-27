##### Variabili
SHELL			= /bin/sh
CARTELLA		= $(shell basename $$(pwd))
GRAV			= gravitazione
GRAV_TEX		= $(GRAV).tex
GRAV_PDF		= $(GRAV).pdf
COSMO			= cosmo
COSMO_TEX		= $(COSMO).tex
COSMO_PDF		= $(COSMO).pdf
BIBLIOGRAFIA		= bibliografia.bib
CAPITOLI_TEX		= $(wildcard capitoli/*.tex) $(wildcard appendici/*.tex)
TUTTI_TEX		= $(GRAV_TEX) $(CAPITOLI_TEX) $(INIZIO_FINE_TEX) \
	$(BIBLIOGRAFIA)
CLEAN_FILE		= *.aux *.bbl *.bcf *.blg *-blx.bib *.fdb_latexmk *.fls \
	*.idx *.ilg *.ind *.lof *.log *.nav *.out *.pgf-plot.* *.run.xml *.snm \
	*.toc *~ $(wildcard capitoli/*~) $(wildcard appendici/*~)
DISTCLEAN_FILE		= *.pdf
##### Regole

.PHONY: all clean distclean dist full-dist

all: $(COSMO_PDF) $(GRAV_PDF)

$(COSMO_PDF): $(COSMO_TEX)
	pdflatex $(COSMO_TEX)
	bibtex $(COSMO)
	makeindex $(COSMO)
	pdflatex $(COSMO_TEX)
	pdflatex $(COSMO_TEX)
	pdflatex $(COSMO_TEX)

$(GRAV_PDF): $(TUTTI_TEX)
	pdflatex $(GRAV_TEX)
	bibtex $(GRAV)
	makeindex $(GRAV)
	pdflatex $(GRAV_TEX)
	pdflatex $(GRAV_TEX)
	pdflatex $(GRAV_TEX)

# Per fare pulizia dei file temporanei generati:
clean:
	rm -f $(CLEAN_FILE)

# Per cancellare tutti i file generati nella compilazione lasciando solo il
# sorgente:
distclean: clean
	rm -f $(DISTCLEAN_FILE)

# Per creare un archivio compresso contenente il sorgente e il repository di git
dist: $(TUTTI_TEX) $(BIBLIOGRAFIA) distclean
	git gc # comprimo il repository di git per ridurre al minimo la tarball
	cd .. && tar -cJvpsf $(CARTELLA).tar.xz --exclude=$(CARTELLA)/auto $(CARTELLA)/

# Crea un archivio compresso (.tar.gz) contenente tutte le immagini e senza il
# repo git
full-dist: all
	cd .. && tar -czvpf $(CARTELLA).tar.gz --exclude=$(CARTELLA)/auto --exclude-vcs $(CARTELLA)/
