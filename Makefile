url_prefix=http://string-db.org/newstring_download/
data_files=$(addprefix data/,protein.links.detailed.v10.txt.gz protein.aliases.v10.txt.gz species.v10.txt entrez2symbol.txt)

interactomes: build_R_network.R data/edge_files data/entrez2symbol.txt
	mkdir -p output
	Rscript $<

data/edge_files: $(data_files) 
	zcat data/protein.links.detailed.v10.txt.gz | ./filter_links.pl 800 | ./extract_species_networks.py ../GeneSets/organisms $(@D)
	touch $@

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

.INTERMEDIATE: $(data_files)

clean:
	rm -fr data output
