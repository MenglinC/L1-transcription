makeblastdb -in hg38_bedtools_TE.chr1-Y.processed.final.50.fasta -dbtype nucl -out hg38_bedtools_TE.chr1-Y.processed.final.50.fasta -parse_seqids
perl ./gRNA_screenTE_mismatch.pl -sgRNA ./gRNA30all.txt -length 30 -mismatch 0 -fastaindex hg38_bedtools_TE.chr1-Y.processed.final.50.fasta
perl ./gRNA_screenTE_mismatch_combine.pl -sgRNA ./gRNA-L1PA2-4.txt -length 30 -mismatch 3 -fastaindex hg38_bedtools_TE.chr1-Y.processed.final.50.fasta
