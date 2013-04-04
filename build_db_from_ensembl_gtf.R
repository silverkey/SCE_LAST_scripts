library(GenomicFeatures)
library(rtracklayer)

transdb = makeTranscriptDbFromGFF('Ciona_intestinalis.JGI2.49.gtf',
                                  format='gtf',
                                  exonRankAttributeName='exon_number',
                                  dataSource='EnsEMBL49',
                                  species='Ciona intestinalis')
saveDb(transdb,file='ciona.sqlite')

transdb = makeTranscriptDbFromGFF('Mus_musculus.NCBIM37.49.gtf',
                                  format='gtf',
                                  exonRankAttributeName='exon_number',
                                  dataSource='EnsEMBL49',
                                  species='Mus musculus')
saveDb(transdb,file='mus.sqlite')

transdb = makeTranscriptDbFromGFF('Danio_rerio.ZFISH7.49.gtf',
                                  format='gtf',
                                  exonRankAttributeName='exon_number',
                                  dataSource='EnsEMBL49',
                                  species='Danio rerio')
saveDb(transdb,file='danio.sqlite')