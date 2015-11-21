#!/usr/bin/python

import sys
import csv
import subprocess
import re

#===============================================================================
# Subroutines
#===============================================================================
def openFile(fileName):
    if fileName.endswith(".gz"):
        cmdArgs = [ "zcat" , fileName ]
        return subprocess.Popen(cmdArgs, stdout=subprocess.PIPE).stdout
    else:
        return file(fileName)

def getTaxIDs(fileName, organismFileName):
    organisms = set([ l.strip() for l in file(organismFileName) ])
    taxIDs = dict()
    for record in csv.DictReader(openFile(fileName), delimiter="\t"):
        for nameField in ("STRING_name_compact", "official_name_NCBI"):
            if record[nameField] in organisms:
                taxIDs[record["## taxon_id"]] = record[nameField]
                break
    return taxIDs
            
def createOutputFiles(taxIDDict, outDir):
    pattern = re.compile(r'\W+')
    files = dict()
    for taxID, name in taxIDDict.items():
        fileName = "%s/%s.edges.txt" % ( outDir, pattern.sub(".", name) )
        files[taxID] = file(fileName, 'w')
    return files

def getOrganismNodeIDs(fileName, taxIDDict):
    entrezPattern = re.compile(r'^\d+$')
    taxIDPattern = re.compile(r'^(\d+)\.')
    node2TaxID = dict()
    node2EntrezID = dict()
    for record in csv.reader(openFile(fileName), delimiter="\t", 
                skipinitialspace=True):
        if record[0].startswith('#'):
            continue
        taxID = taxIDPattern.match(record[0]).group(1)
        if taxID not in taxIDDict:
            continue
        proteinID = record[0]
        alias = record[1]
        if entrezPattern.match(alias) != None and record[2].find('GeneID') > -1:
            nodeID = record[0]
            node2EntrezID[nodeID] = alias
            node2TaxID[nodeID] = taxID
    return node2TaxID, node2EntrezID

#===============================================================================
# Main
#===============================================================================
display = sys.stderr.write
proteinAliasFileName = "data/protein.aliases.v10.txt.gz"
#proteinAliasFileName = "data/human_aliases.txt"
speciesFileName = "data/species.v10.txt"
organismFileName = sys.argv[1]
outDir = sys.argv[2]

display("Looking up taxonomy ID...")
taxIDs = getTaxIDs(speciesFileName, organismFileName)
display("\nRetrieving nodes...")
node2TaxID, node2EntrezID = getOrganismNodeIDs(proteinAliasFileName, taxIDs)
display(" %d nodes found." % len(node2EntrezID))

display("\nExtracting network ")
edgesSeen = set()
outFields = ["protein1", "protein2", "neighborhood", "fusion", "cooccurence", 
        "coexpression", "experimental", "database", "textmining", 
        "combined_score"]

outputFiles = createOutputFiles(taxIDs, outDir)
for f in outputFiles.values():
    print >>f, str.join("\t", outFields)
for record in csv.DictReader(sys.stdin, delimiter=" ", fieldnames=outFields):
    if record["protein1"] not in node2EntrezID or record["protein2"] not in node2EntrezID:
        continue
    if node2TaxID[record["protein1"]] != node2TaxID[record["protein2"]]:
        continue
    taxID = node2TaxID[record["protein1"]]
    record["protein1"] = node2EntrezID[record["protein1"]]
    record["protein2"] = node2EntrezID[record["protein2"]]
    edgeTuple = tuple(sorted((record["protein1"], record["protein2"])))
    if edgeTuple in edgesSeen:
        continue
    edgesSeen.add(edgeTuple)
    if len(edgesSeen) % 10000 == 0:
        display(".")
    print >>outputFiles[taxID], str.join("\t", [ record[f] for f in outFields ] )
display("\n%d edges written.\n" % len(edgesSeen))
for f in outputFiles.values():
    f.close()

