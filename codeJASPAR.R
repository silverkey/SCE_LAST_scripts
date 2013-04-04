of = read.table(file='fugu_ocne_jaspar_fam.txt',sep='\t',header=T,quote='',comment.char='')
nf = read.table(file='fugu_negrcne_jaspar_fam.txt',sep='\t',header=T,quote='',comment.char='')

tab = c()
class = as.character(unique(of$tfname))
tab$class = class

res = c()
for(i in 1:length(class)) {
  res = c(res,length(unique(of[of$tfname == class[i],]$seqid)))
}
tab$ocne = res

res = c()
for(i in 1:length(class)) {
  res = c(res,length(unique(nf[nf$tfname == class[i],]$seqid)))
}
tab$negrcne = res

tab = as.data.frame(tab)

p = c()
for(i in 1:nrow(tab)) {
  p = c(p,prop.test(c(tab[i,'ocne'],tab[i,'negrcne']),c(183,204),alternative='g')$p.value)
}

tab$p = p
tab$adj.p = p.adjust(p,method='BH')

write.table(tab,file='fugu_tfbs.xls',sep='\t',quote=F,row.names=F)




of = read.table(file='mouse_ocne_jaspar_fam.txt',sep='\t',header=T,quote='',comment.char='')
nf = read.table(file='mouse_negrcne_jaspar_fam.txt',sep='\t',header=T,quote='',comment.char='')

tab = c()
class = as.character(unique(of$tfname))
tab$class = class

res = c()
for(i in 1:length(class)) {
  res = c(res,length(unique(of[of$tfname == class[i],]$seqid)))
}
tab$ocne = res

res = c()
for(i in 1:length(class)) {
  res = c(res,length(unique(nf[nf$tfname == class[i],]$seqid)))
}
tab$negrcne = res

tab = as.data.frame(tab)

p = c()
for(i in 1:nrow(tab)) {
  p = c(p,prop.test(c(tab[i,'ocne'],tab[i,'negrcne']),c(183,204),alternative='g')$p.value)
}

tab$p = p
tab$adj.p = p.adjust(p,method='BH')

write.table(tab,file='mouse_tfbs.xls',sep='\t',quote=F,row.names=F)








of = read.table(file='ciona_ocne_jaspar_fam.txt',sep='\t',header=T,quote='',comment.char='')
nf = read.table(file='ciona_negrcne_jaspar_fam.txt',sep='\t',header=T,quote='',comment.char='')

tab = c()
class = as.character(unique(of$tfname))
tab$class = class

res = c()
for(i in 1:length(class)) {
  res = c(res,length(unique(of[of$tfname == class[i],]$seqid)))
}
tab$ocne = res

res = c()
for(i in 1:length(class)) {
  res = c(res,length(unique(nf[nf$tfname == class[i],]$seqid)))
}
tab$negrcne = res

tab = as.data.frame(tab)

p = c()
for(i in 1:nrow(tab)) {
  p = c(p,prop.test(c(tab[i,'ocne'],tab[i,'negrcne']),c(183,203),alternative='g')$p.value)
}

tab$p = p
tab$adj.p = p.adjust(p,method='BH')

write.table(tab,file='ciona_tfbs.xls',sep='\t',quote=F,row.names=F)
