# SetRank_interactomes
A set of scripts to build interactome objects for use with the SetRank package. 

## System requirements

This set of scripts should work on any basic Linux / Mac OS X installation. You need to have the following installed:
* GNU Make
* The `wget` utility
* Python 2.7 or later
* Perl 5.16 (earlier versions will probably work as well)
* R version 3.1.1 or later with the [igraph](http://igraph.org/r/) module installed

## Installation and use

To install, simply clone this repository onto your local machine. You first need to edit the `organisms` file to specify for which organisms you wish to build interactomes. Each line must contain one organism name and not contain any trailing or leading spaces. You must use the exact same species name as used in the [NCBI Taxonomy database](http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi). For micro-organisms, you typically want to include the strain name as well, e.g. Escherichia coli str. K-12 substr. MG1655. The repository already includes an `organisms` file, you can look there for examples.

Once you have updated the `organisms` file, all you have to do is run the `make` command from the `SetRank_interactomes` directory. Running make will download interaction data from the [STRING](http://string-db.org/) interaction database. This data will automatically be parsed and for each organism listed in the `organisms` file, an R data file will be created in a subdirectory called `output`. Each file has a file name in in the format of `<Genus.species>_<YY.MM.DD>.Rda` where `<Genus.species>` is the name of the species and `<YY.MM.DD>` is a datestamp/version number and contains a single R object named `string`. This object can be passed on to the `exportGeneNets` function of the SetRank package. See the documentation of the main SetRank package for more information.

