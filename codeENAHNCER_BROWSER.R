uce = read.table(file='ebtab.xls',sep='\t',quote='',comment.char='',header=F)
colnames(uce) = c('uce','res')
uce = uce[uce$res == 'positive' | uce$res == 'negative',]

nrow(uce)
# 1756

sum(uce$res=='positive')
# 887

sum(uce$res!='positive')
# 869


bl = read.table(file='mouse_ocne_vs_ebseq.tab',sep='\t',quote='',comment.char='',header=T)
bl = bl[,c(1,2)]

nrow(m)
# 85

m = merge(bl,uce,by.x='hit',by.y='uce',all.x=T)
m = unique(m[,c(2,1,3)])

nrow(m[m$res=='positive',])
# 56

nrow(m[m$res!='positive',])
# 29


prop.test(c(56,887),c(85,1756),alternative='g')

> prop.test(c(56,887),c(85,1756),alternative='g')

2-sample test for equality of proportions with continuity correction

data:  c(56, 887) out of c(85, 1756) 
X-squared = 7.0628, df = 1, p-value = 0.003935
alternative hypothesis: greater 
95 percent confidence interval:
0.0606996 1.0000000 
sample estimates:
prop 1    prop 2 
0.6588235 0.5051253 
