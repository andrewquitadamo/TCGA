tab = read.table('res.TCGA.all.05')

ind<-which(abs(tab)>1, arr.ind=T)

write.table(file='ind',ind,sep="\t",col.names=F,row.names=F)

Exp.cols<-read.table('ExpressionMatrix.colNames',stringsAsFactors=F)
Meth.cols<-read.table('Methylation.colNames',stringsAsFactors=F)

Meth.names<-vector(len=length(ind)/2)
Gene.names<-vector(len=length(ind)/2)

for (i in 1:length(ind)/2)
{
	Meth.names[i]<-(Meth.cols[ind[i,][1],1])
	Gene.names[i]<-(Exp.cols[ind[i,][2],1])
}

names.df<-data.frame(Meth.names,Gene.names)

write.table(file='names_05',names.df,quote=F,sep="\t",col.names=F,row.names=F)

#meth.tab<-table(ind[,1])
#gene.tab<-table(ind[,2])

meth.ind<-ind[,1]
gene.ind<-ind[,2]

gene.freq<-vector(len=length(gene.ind))
for (i in 1:length(gene.ind))
{
	gene.freq[i]<-(Gene.names[i])
}

gene.tab<-table(gene.freq)

meth.freq<-vector(len=length(meth.ind))
for (i in 1:length(meth.ind))
{
	meth.freq[i]<-(Meth.names[i])
}

meth.tab<-table(meth.freq)

write.table(file='gene_freq_table_05',gene.tab,quote=F,sep="\t",col.names=F,row.names=F)
write.table(file='meth_freq_table_05',meth.tab,quote=F,sep="\t",col.names=F,row.names=F)
