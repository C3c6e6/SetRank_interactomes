library(igraph)

conversionTable = read.table("data/entrez2symbol.txt", sep="\t", 
        colClasses="character", quote="", row.names=1)
entrez2Symbol = conversionTable$V2
names(entrez2Symbol) = rownames(conversionTable)

inputTable = read.table(file('stdin'), header=TRUE, sep="\t", quote="",
        colClasses=c("protein1"="character", "protein2"="character"))
dummy = by(inputTable, inputTable$organism, function(edgeTable) {
    organism = make.names(unique(as.character(edgeTable$organism)))
    organism = gsub("\\.+", "\\.", gsub("(sub)?str", ".", organism))
    version = gsub("-", ".", substr(Sys.Date(), 3, 20))
    outFile = sprintf("%s/%s_%s.Rda", "output", organism, version)
    message("Creating ", outFile) 
    nodeTable = data.frame(
            node=unique(c(edgeTable$protein1, edgeTable$protein2)),
            stringsAsFactors=FALSE)
    nodeTable$symbol = entrez2Symbol[nodeTable$node]
    string = graph.data.frame(edgeTable, FALSE, vertices=nodeTable)
    save(string, file=outFile)
})

