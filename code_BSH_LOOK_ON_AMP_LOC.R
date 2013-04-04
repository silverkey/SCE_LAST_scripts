t = read.table(file='tun_vert_ocne_genes_asso.txt',sep='\t',header=T)
t = unique(t)

ma = read.table(file='BSH_mus_amp.txt',sep='\t',header=T)
ma = ma[ma$coverage>=50,]

ca = read.table(file='BSH_cio_amp.txt',sep='\t',header=T)
ca = ca[ca$coverage>=50,]

mid = read.table(file='mus_id.txt',sep='\t',header=T)
cid = read.table(file='ciona_id.txt',sep='\t',header=T)

amp = read.table(file='Bfloridae_v1.0_FilteredModelsMappedToAssemblyv2.0.tab',sep='\t',comment.char='',quote='')
colnames(amp) = c('pid','chr','start','end','strand')

ma.gid = merge(ma,mid,by.x='clone',by.y='pid',all.y=T)
ma.gid = ma.gid[,c(9,2)]
ma.gid.amp = merge(ma.gid,amp,by.x='hit',by.y='pid')
ma.gid.amp = unique(ma.gid.amp[,c(1,2,3)])

ca.gid = merge(ca,cid,by.x='clone',by.y='pid',all.y=T)
ca.gid = ca.gid[,c(9,2)]
ca.gid.amp = merge(ca.gid,amp,by.x='hit',by.y='pid')
ca.gid.amp = unique(ca.gid.amp[,c(1,2,3)])

tm = merge(t,ma.gid.amp,by.x='mensid',by.y='gid',all.x=T)
tm = tm[,c(2,1,4,5,3)]
colnames(tm) = c('ocne','mensid','mhit','mchr','censid')

tma = merge(tm,ca.gid.amp,by.x='censid',by.y='gid',all.x=T)
tma = tma[,c(2,3,4,5,1,6,7)]
colnames(tma) = c('ocne','mensid','mhit','mchr','censid','chit','cchr')

na.omit(tma[tma$mchr == tma$cchr,])





t = read.table(file='tun_vert_ocne_genes_asso.txt',sep='\t',header=T)
t = unique(t)
ma = read.table(file='BSH_mus_amp.txt',sep='\t',header=T)
ma = ma[ma$coverage>=50,]
ca = read.table(file='BSH_cio_amp.txt',sep='\t',header=T)
ca = ca[ca$coverage>=50,]
mid = read.table(file='mus_id.txt',sep='\t',header=T)
cid = read.table(file='ciona_id.txt',sep='\t',header=T)
amp = read.table(file='Bfloridae_v1.0_FilteredModelsMappedToAssemblyv2.0.tab',sep='\t',comment.char='',quote='')
colnames(amp) = c('pid','chr','start','end','strand')

res = c()

for(i in 1:1000) {

ma$clone = sample(ma$clone)

ca$clone = sample(ca$clone)

ma.gid = merge(ma,mid,by.x='clone',by.y='pid',all.y=T)
ma.gid = ma.gid[,c(9,2)]
ma.gid.amp = merge(ma.gid,amp,by.x='hit',by.y='pid')
ma.gid.amp = unique(ma.gid.amp[,c(1,2,3)])

ca.gid = merge(ca,cid,by.x='clone',by.y='pid',all.y=T)
ca.gid = ca.gid[,c(9,2)]
ca.gid.amp = merge(ca.gid,amp,by.x='hit',by.y='pid')
ca.gid.amp = unique(ca.gid.amp[,c(1,2,3)])

tm = merge(t,ma.gid.amp,by.x='mensid',by.y='gid',all.x=T)
tm = tm[,c(2,1,4,5,3)]
colnames(tm) = c('ocne','mensid','mhit','mchr','censid')

tma = merge(tm,ca.gid.amp,by.x='censid',by.y='gid',all.x=T)
tma = tma[,c(2,3,4,5,1,6,7)]
colnames(tma) = c('ocne','mensid','mhit','mchr','censid','chit','cchr')

res = c(res,nrow(na.omit(tma[tma$mchr == tma$cchr,])))
  
}  
