#/bin/bash -e
# 180328145621
# usage: ./script.sh ./mafs > all.sorted.minimal.vcf

input_dir=${1?} && shift

vcf_version="v4.1" # TODO: as param

function process() {
    input_file=${1?} && shift
  allele_index=${1?} && shift
  
  sample=$(basename ${input_file?} | cut -d'.' -f1)
  
  # 5=chr, 6=start, 11=ref
  awk -F$'\t' '$11!=$'${allele_index?}'{print $5 "\t" $6 "\t\t" $11 "\t" $'${allele_index?}' "\t\t\tID=" "'${sample?}'" "@" NR "@" '${allele_index?}'}'
}

{
  echo -e "##fileformat=VCF${vcf_version?}\n#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO"
  for f in $(ls ${input_dir?}/*.maf.gz | sort); do
    zcat $f | tail -n+3 | process $f 12 # 12=Tumor_Seq_Allele1
    zcat $f | tail -n+3 | process $f 13 # 13=Tumor_Seq_Allele2
  done | sort -t$'\t' -k1,1 -k2n,2n
} | gzip -c
