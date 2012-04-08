##### Variabili
SHELL			= /bin/sh
CARTELLA		= $(shell basename $$(pwd))
PRINCIPALE		= astrofisica-teorica
PRINCIPALE_TEX		= $(PRINCIPALE).tex
PRINCIPALE_PDF		= $(PRINCIPALE).pdf
BIBLIOGRAFIA		= bibliografia.bib
CAPITOLI_TEX		= $(wildcard capitoli/*.tex)
INIZIO_FINE_TEX		= $(wildcard MaterialeInizialeFinale/*.tex)
TUTTI_TEX		= $(PRINCIPALE_TEX) $(CAPITOLI_TEX) $(INIZIO_FINE_TEX)
CLEAN_FILE		= *.aux *.bbl *.bcf *.blg *-blx.bib *.fdb_latexmk *.idx \
	*.ilg *.ind *.lof *.log *.nav *.out *.pgf-plot.* *.run.xml *.snm \
	*.toc *~ $(wildcard capitoli/*~) $(wildcard MaterialeInizialeFinale/*~) \
DISTCLEAN_FILE		= *.pdf
##### Regole

.PHONY: pdf clean distclean dist full-dist

pdf: $(PRINCIPALE_PDF)

$(PRINCIPALE_PDF): $(TUTTI_TEX)
	latexmk -pdf $(PRINCIPALE_TEX)

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

# Crea un archivio compresso (.tar.xz) contenente tutte le immagini e senza il
# repo git
full-dist: $(PRINCIPALE_PDF) clean
	cd .. && tar -cJvpsf $(CARTELLA).tar.xz --exclude=$(CARTELLA)/auto --exclude-vcs $(CARTELLA)/
