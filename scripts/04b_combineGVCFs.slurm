#!/bin/bash
#SBATCH --job-name=Laspl_combine_gvcfs
#SBATCH --output=04_gatk/Laspl/logs/combine_gvcfsSpl.%j.out
#SBATCH --error=04_gatk/Laspl/err/combine_gvcfsSpl.%j.err
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G
#SBATCH --partition=krypton

module load gnu python python-packages
module load gatk

INDIR=04_gatk/Laspl/gvcf
OUT=04_gatk/Laspl/combined/combined-Laspl.g.vcf.gz
REF=reference/Laspl/LaSpl_GerMun_scaffolded_2023.fasta

gatk CombineGVCFs \
  -R "$REF" \
  $(for f in "$INDIR"/*.g.vcf.gz; do echo -V "$f"; done) \
  -O "$OUT"
