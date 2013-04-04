library(GenomicFeatures)
library(rtracklayer)

analize = function(dbfile,species,file.id,tab) {
  
  trdb = loadDb(dbfile)
  tab.ocne = tab[tab$organism == species,]
  tab.id = read.table(file=file.id,head=T)
  
  transcript = transcripts(trdb)
  
  id = 1
  chr = 3
  start = 4
  end = 5
  strand = 6
  
  source.tab = tab.ocne
  ncol.f = ncol(source.tab)
  selected = source.tab[,c(id,chr,start,end,strand)]
  colnames(selected) = c('id','chr','start','end','strand')
  
  ranges = GRanges(seqnames=Rle(selected$chr),
                   ranges=IRanges(start=selected$start,end=selected$end),
                   strand=Rle(selected$strand),
                   id=selected$id)

  # Give to all the + strand otherwise the interpretation of precede and follow
  # will take the strand into account giving misleading results
  strand(transcript) = '+'
  strand(ranges) = '+'
  # Limit to the transcripts present into tab.id wich contains only the id of
  # the protein coding genes (it comes from the perl script extract_id_from_ensembl_gtf.pl
  transcript = transcript[transcript$tx_name %in% tab.id$tid]
  
  ids = c()
  flanking = c()
  
  for(i in 1:length(ranges)) {  
    
    id = ranges[i]$id
    
    # Limit to the chromosome containing the range to check because the function work
    # only considering start and end and strand
    chrtr = transcript[seqnames(transcript) == as.character(seqnames(ranges[i]))]
    # Get the overlap
    ov = nearest(ranges[i],chrtr)
    # Get the next feature in chrtr (precede is referred to the query i.e. ranges[i])
    up = precede(ranges[i],chrtr)
    # Get the previous feature in chrtr (follow is referred to the query i.e. ranges[i])
    down = follow(ranges[i],chrtr)
    
    if(!is.na(ov)) {
      ids = c(ids,id)
      flanking = c(flanking,chrtr[ov]$tx_name)
    }
    
    if(!is.na(up)) {
      ids = c(ids,id)
      flanking = c(flanking,chrtr[up]$tx_name)
    }
    
    if(!is.na(down)) {
      ids = c(ids,id)
      flanking = c(flanking,chrtr[down]$tx_name)
    }
  }
  
  res.tab = unique(data.frame(ids,flanking))
  res.tab.id = merge(res.tab,tab.id,by.x='flanking',by.y='tid')
  final = unique(res.tab.id[,c('ids','gid')])
  
  final
}

tab = read.table(file='../supp_table1.txt',sep='\t',head=T)

dbfile = 'ciona.sqlite'
species = 'Ciona intestinalis'
file.id = 'ciona_id.txt'
cio = analize(dbfile,species,file.id,tab)
write.table(cio,file='ciona_ocne_flanking.txt',sep='\t',quote=F,row.names=F)

dbfile = 'mus.sqlite'
species = 'Mus musculus'
file.id = 'mus_id.txt'
mus = analize(dbfile,species,file.id,tab)
write.table(mus,file='mus_ocne_flanking.txt',sep='\t',quote=F,row.names=F)

dbfile = 'danio.sqlite'
species = 'Danio rerio'
file.id = 'danio_id.txt'
danio = analize(dbfile,species,file.id,tab)
write.table(danio,file='danio_ocne_flanking.txt',sep='\t',quote=F,row.names=F)







# TO PREPARE THE TABLE FOR THE CIONA ANNOTATION
# amodels = read.table(file='aniseed_models.xls',sep='\t',head=T,comment.char='',quote='')
# bmodels = amodels[amodels$blast != '\\N',c(1,4)]
# cmodels = bmodels[grep('ENSCIN',bmodels$id),]
# file.id = 'ciona_id.txt'
# tab.id = read.table(file=file.id,head=T)
# cio.anno = merge(tab.id,cmodels,by.x='tid',by.y='id',all.x=T)
# res.cio.anno = merge(cio,cio.anno,by.x='gid',by.y='gid')
# res.cio.anno = unique(res.cio.anno[,c('gid','blast')])
