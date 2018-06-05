#!/bin/bash -e
# 180605100515

wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/liftOver
wget http://hgdownload.cse.ucsc.edu/goldenPath/hg19/liftOver/hg19ToHg38.over.chain.gz

echo -e "chr1\t103354135\t103354136\t1
chr1\t104120227\t104120228\t2
chr1\t104163266\t104163267\t3" > in.bed

./liftOver in.bed hg19ToHg38.over.chain.gz out.bed unmapped.bed # in.bed is chr,pos,pos+1,id
