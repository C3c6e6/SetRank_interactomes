url_prefix=https://stringdb-static.org/download/
v=10.5
data_files=$(addprefix data/,protein.links.detailed.v${v}.txt.gz protein.aliases.v${v}.txt.gz species.v${v}.txt entrez2symbol.txt)

interactomes: data/entrez2symbol.txt $(data_files)
	mkdir -p output
	zcat data/protein.links.detailed.v${v}.txt.gz | perl filter_links.pl 750 | python2.7 extract_edges_per_species.py data/protein.aliases.v${v}.txt.gz data/species.v${v}.txt organisms | Rscript build_interactomes.R

data/species.v${v}.txt:    
	mkdir -p $(@D)
	wget --quiet -P $(@D) -nd $(url_prefix)species.v${v}.txt

data/%.txt.gz:
	mkdir -p $(@D)
	wget --quiet -P $(@D) -nd $(url_prefix)/$(@F)

data/entrez2symbol.txt: data/gene_info.gz
	zcat $< | tail -n +2 | cut -f 2,3 > $@

data/gene_info.gz:
	mkdir -p $(@D)
	wget --quiet -P $(@D) -nd ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz

clean:
	rm -fr data 
