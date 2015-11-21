library(igraph)


conversionTable = read.table("data/entrez2symbol.txt", sep="\t", 
        colClasses="character", quote="", row.names=1)
entrez2Symbol = conversionTable$V2
names(entrez2Symbol) = rownames(conversionTable)

for (edgeFile in Sys.glob("data/*.edges.txt")) {
    version = gsub("-", ".", substr(Sys.Date(), 3, 20))
    outFile = sprintf("%s/%s.%s.Rda", "output",
            sub("\\.edges.txt$", "", basename(edgeFile)), version)
    message("Creating ", outFile) 
    edgeTable = read.table(edgeFile, sep="\t", header=TRUE, 
            stringsAsFactors=FALSE, 
            colClasses=c("protein1"="character", "protein2"="character"))
    nodeTable = data.frame(
            node=unique(c(edgeTable$protein1, edgeTable$protein2)),
            stringsAsFactors=FALSE)
    nodeTable$symbol = entrez2Symbol[nodeTable$node]
    string = graph.data.frame(edgeTable, FALSE, vertices=nodeTable)
    save(string, file=outFile)
}

