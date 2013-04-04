library(GenomicFeatures)
library(rtracklayer)

id = 1
chr = 2
start = 3
end = 4
strand = 5

source.tab = read.table(file='Brafl1.FilteredModels1.tab')
ncol.f = ncol(source.tab)
selected = source.tab[,c(id,chr,start,end,strand)]
colnames(selected) = c('id','chr','start','end','strand')

ranges = GRanges(seqnames=Rle(selected$chr),
                 ranges=IRanges(start=selected$start,end=selected$end),
                 strand=Rle(selected$strand),
                 id=selected$id)

