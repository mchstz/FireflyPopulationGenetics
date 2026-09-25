#!/bin/bash
#SBATCH --job-name=spl_f_hc
#SBATCH --partition=krypton
#SBATCH --ntasks=1
#SBATCH --mem=32G
#SBATCH --array=1-15
#SBATCH -o 04_gatk/Laspl/logs/hc_spl_%A_%a.out
#SBATCH -e 04_gatk/Laspl/err/hc_spl_%A_%a.err

module load gnu python python-packages
module load gatk

BAM=03_dedup/Laspl/ChrX
OUT=04_gatk/Laspl/gvcf/ChrX
SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" utils/sample_listSplDiploid_F.txt)

mkdir "$OUT"

gatk HaplotypeCaller \
  -R reference/Laspl/LaSpl_GerMun_scaffolded_2023.fasta \
  -I "$BAM"/${SAMPLE}_dedup_q20_ChrX.bam \
  -O "$OUT"/${SAMPLE}_ChrX.g.vcf.gz \
  --sample-ploidy 2 \
  -ERC GVCF
