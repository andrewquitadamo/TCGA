all: Expression MethylationMat Normalize Correlation Genes

Expression: ExpressionMatrix.final ExpressionMatrix.colNames ExpressionMatrix.out.noh ExpressionMatrix.header

MethylationMat: Methylation.final Methylation.colNames Methylation.out.noh Methylation.header

Normalize: ExpressionMatrix.meqtl Methylation.meqtl

Correlation: cis.eqtls.04

Genes: cis.eqtls.04.genes.dapple cis.eqtls.04.cpgs.genes.dapple cis.eqtls.04.cpgs.genes cis.eqtls.04.cpgs

ExpressionMatrix.final: ExpressionMatrix.out.noh
	cut -f 2- ExpressionMatrix.out.noh > ExpressionMatrix.final

ExpressionMatrix.colNames: ExpressionMatrix.out.noh
	cut -f 1 ExpressionMatrix.out.noh > ExpressionMatrix.colNames

ExpressionMatrix.out.noh: ExpressionMatrix.out
	sed '1d' ExpressionMatrix.out > ExpressionMatrix.out.noh

ExpressionMatrix.header: ExpressionMatrix.out
	sed -n '1p' ExpressionMatrix.out > ExpressionMatrix.header

ExpressionMatrix.out: ExpressionMatrix Methylation
	perl overlap.pl Methylation ExpressionMatrix

Methylation.final: Methylation.out.noh
	cut -f 2- Methylation.out.noh > Methylation.final

Methylation.colNames: Methylation.out.noh
	cut -f 1 Methylation.out.noh > Methylation.colNames

Methylation.out.noh: Methylation.out
	sed '1d' Methylation.out > Methylation.out.noh

Methylation.header: Methylation.out
	sed -n '1p' Methylation.out > Methylation.header

Methylation.out: Methylation ExpressionMatrix
	perl overlap.pl Methylation ExpressionMatrix

ExpressionMatrix.meqtl: ExpressionMatrix.final ExpressionMatrix.colNames ExpressionMatrix.header expr_norm.R quantile_norm_func.r
	R --no-save < expr_norm.R

Methylation.meqtl: Methylation.final Methylation.colNames Methylation.header meth_norm.R quantile_norm_func.r
	R --no-save < meth_norm.R

cis.eqtls.04: runMEQTL.R CorrBoxPlot.R ExpressionMatrix.meqtl Methylation.meqtl runCorr.R
	R --no-save < runCorr.R

runMEQTL.R: ExpressionMatrix.meqtl Methylation.meqtl cpg_position gene_position

cis.eqtls.04.genes: cis.eqtls.04
	cut -d'|' -f 1 cis.eqtls.04 | cut -f 2 | sed '1d' | sort | uniq > cis.eqtls.04.genes

cis.eqtls.04.cpgs: cis.eqtls.04
	cut -f 1 cis.eqtls.04 |sed '1d'| sort | uniq > cis.eqtls.04.cpgs

cis.eqtls.04.cpgs.genes: cis.eqtls.04.cpgs cpg_to_gene.pl
	perl cpg_to_gene.pl cis.eqtls.04.cpgs | sort | uniq > cis.eqtls.04.cpgs.genes

cis.eqtls.04.cpgs.genes.dapple: cis.eqtls.04.cpgs.genes dapple_gene.pl
	perl dapple_gene.pl cis.eqtls.05.cpgs.genes > cis.eqtls.04.cpgs.genes.dapple

cis.eqtls.04.genes.dapple: cis.eqtls.04.genes dapple_gene.pl
	perl dapple_gene.pl cis.eqtls.04.genes > cis.eqtls.04.genes.dapple
