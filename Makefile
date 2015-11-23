url_prefix=http://string-db.org/newstring_download/
data_files=$(addprefix data/,protein.links.detailed.v10.txt.gz protein.aliases.v10.txt.gz species.v10.txt entrez2symbol.txt)

interactomes: data/entrez2symbol.txt $(data_files)
	mkdir -p output
	zcat data/protein.links.detailed.v10.txt.gz | perl filter_links.pl 750 | python extract_edges_per_species.py ../GeneSets/organisms | Rscript build_interactomes.R

data/species.v10.txt:    
	mkdir -p $(@D)
	wget --quiet -P $(@D) -nd $(url_prefix)species.v10.txt

data/%.txt.gz:
	mkdir -p $(@D)
	wget --quiet -P $(@D) -nd $(url_prefix)/$(@F)

data/entrez2symbol.txt: data/gene_info.gz
	zcat $< | tail -n +2 | cut -f 2,3 > $@

data/gene_info.gz:
	mkdir -p $(@D)
	wget --quiet -P $(@D) -nd ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene_info.gz

.INTERMEDIATE: $(data_files) data/gene_info.gz

clean:
	rm -fr data 
