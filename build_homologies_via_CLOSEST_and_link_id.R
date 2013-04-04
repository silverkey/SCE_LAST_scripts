library(GenomicFeatures)
library(rtracklayer)

make.ranges.from.tab = function(tab,id,chr,start,end,strand) {

  ncol.f = ncol(tab)
  selected = tab[,c(id,chr,start,end,strand)]
  colnames(selected) = c('id','chr','start','end','strand')

  ranges = GRanges(seqnames=Rle(selected$chr),
                   ranges=IRanges(start=selected$start,end=selected$end),
                   strand=Rle(selected$strand),
                   id=selected$id)
  ranges
}

ocne = read.table(file='amp.ocnes.txt',sep='\t',head=T)
t.tab = read.table(file='Brafl1.FilteredModels1.tab')
ocne$strand = '+'

rocne = make.ranges.from.tab(ocne,1,5,6,7,9)
rtr = make.ranges.from.tab(t.tab,1,2,3,4,5)

strand(rocne) = '+'
strand(rtr) = '+'

ids = c()
flanking = c()
for(i in 1:length(rocne)) {  
  id = rocne[i]$id
  # Limit to the chromosome containing the range to check because the function work
  # only considering start and end and strand
  chrtr = rtr[seqnames(rtr) == as.character(seqnames(rocne[i]))]
  # Get the overlap
  ov = nearest(rocne[i],chrtr)
  # Get the next feature in chrtr (precede is referred to the query i.e. ranges[i])
  up = precede(rocne[i],chrtr)
  # Get the previous feature in chrtr (follow is referred to the query i.e. ranges[i])
  down = follow(rocne[i],chrtr)  
  if(!is.na(ov)) {
    ids = c(ids,id)
    flanking = c(flanking,as.character(chrtr[ov]$id))
  }  
  if(!is.na(up)) {
    ids = c(ids,id)
    flanking = c(flanking,as.character(chrtr[up]$id))
  }  
  if(!is.na(down)) {
    ids = c(ids,id)
    flanking = c(flanking,as.character(chrtr[down]$id))
  }
}
res.tab = unique(data.frame(ids,flanking))

brh = read.table(file='BRH_mus_amp.txt',sep='\t')
names(brh) = c('mus','amp')
mus.id = read.table(file='mus_id.txt',sep='\t',head=T)

res.brh = merge(res.tab,brh,by.x='flanking',by.y='amp',all.x=T)
res.brh = res.brh[order(res.brh$ids),]
res.id.final = merge(res.brh,mus.id,by.x='mus',by.y='pid',all.x=T)

write.table(res.id.final,file='amp.flanking.mus.homol.xls',sep='\t',row.name=F)

ann = read.table(file='mus.anno.and.dev.txt',comment.char='',quote='',header=T,sep='\t')

res.anno = merge(res.id.final,ann,by.x='gid',by.y='id',all.x=T)
write.table(res.anno,file='amp.flanking.mus.homol.anno.xls',sep='\t',row.name=F)




seed <- as.double(1)
RANDU <- function() {
  seed <<- ((2^16 + 3) * seed) %% (2^31)
  seed/(2^31)
}
for(i in 1:400) {
  U <- c(RANDU(), RANDU(), RANDU(), RANDU(), RANDU())
  print(round(U[1:3], 6))
}
