# SetRank_interactomes
A set of scripts to build interactome objects for use with the SetRank package. 

## System requirements

This set of scripts should work on any basic Linux / Mac OS X installation. You need to have the following installed:
* The wget utility
* Python 2.7 or later
* Perl 5.16 (earlier versions will probably work as well)
* R version 3.1.1 or later with the [igraph](http://igraph.org/r/)module installed

## Installation

Simply clone this repository onto your local machine. You first need to edit the organisms file to specify for which organisms you wish to build interactomes. Each line must contain one organism name and not contain any trailing or leading spaces. You must use the exact same species name as used in the [NCBI Taxonomy database](http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi). For micro-organisms, you typically want to include the strain name as well. The repository already contains an organisms file.

