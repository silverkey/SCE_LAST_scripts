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

t.tab = read.table(file='Oikopleura_annot_v1.0.tab')

hmm = read.table(file='selected_oiko_hmm_res.xls',sep='\t',header=T,quote='',comment.char='')
hmm$strand = '+';
for(i in 1:nrow(hmm)) {
  if(hmm[i,'hit_start'] > hmm[i,'hit_end']) {
    hmm[i,] = hmm[i,c(1,2,4,3,5)]
  }
}
  
rocne = make.ranges.from.tab(hmm,1,2,3,4,5)
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

#----------------------
#cambio annotazioni usiamo solo la roba alla fine e ci mettiamo le annotazioni di b2go
#----------------------
#brh = read.table(file='BRH_cio_oiko.txt',sep='\t')
#names(brh) = c('cio','oiko')
#cio.id = read.table(file='ciona_id.txt',sep='\t',head=T)
#
#res.brh = merge(res.tab,brh,by.x='flanking',by.y='oiko',all.x=T)
#res.brh = res.brh[order(res.brh$ids),]
#res.id.final = merge(res.brh,cio.id,by.x='cio',by.y='pid',all.x=T)
#
#write.table(res.id.final,file='oiko.flanking.cio.homol.xls',sep='\t',row.name=F)
#
#anis = read.table(file='aniseed_models.xls',comment.char='',quote='',head=T,sep='\t')
#anis=anis[anis$blast != '\\N',]
#anis=anis[,c(1,4)]
#
#res.anno = merge(res.id.final,anis,by.x='tid',by.y='id',all.x=T)
#write.table(res.anno,file='oiko.flanking.cio.homol.anno.xls',sep='\t',row.name=F)
#
#fla = read.table(file='ciona_ocne_flanking.txt',sep='\t',header=T)
#colnames(fla)=c('ids','oCNE.associated')
#res.anno.fla = merge(res.anno,fla,by.x='ids',by.y='ids',all.x=T)
#
#oiko.prot = as.character(unique(res.id.final$flanking))
#write.table(oiko.prot,file='flanking.oiko',row.names=F,quote=F)
#-----------------------

cio.id = read.table(file='ciona_id.txt',sep='\t',head=T)
fla = read.table(file='ciona_ocne_flanking.txt',sep='\t',header=T)
anis = read.table(file='aniseed_models.xls',comment.char='',quote='',head=T,sep='\t')

fla.cio = merge(fla,cio.id,by.x='oCNE.associated',by.y='gid',all.x=T)
fla.cio = fla.cio[,c(2,3)]
fla.cio.ani = merge(fla.cio,anis,by.x='tid',by.y='id',all.x=T)
fla.cio.ani = unique(fla.cio.ani)

oiko.ocne = read.table(file='B2GO_oiko_anno.txt',sep='\t')
colnames(oiko.ocne) = c('id','def')

oiko.ocne.id = merge(res.tab,oiko.ocne,by.x='flanking',by.y='id',all.x=T)
tun.oiko.ass = merge(fla.cio.ani,oiko.ocne.id,by.x='ids',by.y='ids',all.y=T)

write.table(tun.oiko.ass,file='tun_oiko_ocnes_associations.xls',,sep='\t',row.names=F,quote=F)
