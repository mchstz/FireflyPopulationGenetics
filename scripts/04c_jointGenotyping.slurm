#!/bin/bash
#SBATCH --job-name=M_SplJoint
#SBATCH --mem=64G
#SBATCH --partition=krypton
#SBATCH -o /home/mstrehl/fireflies/04_gatk/logs/joint_spl_M.out
#SBATCH -e /home/mstrehl/fireflies/04_gatk/err/joint_spl_M.err
#SBATCH --qos=high_prio

module load gnu python python-packages
module load gatk

gatk GenotypeGVCFs \
  -R reference/Laspl/LaSpl_GerMun_scaffolded_2023.fasta \
  -V 04_gatk/Laspl/combined/ChrX/combined-Laspl_ChrX_M.g.vcf.gz \
  -O 04_gatk/Laspl/joint/ChrX/rawSpl_ChrX_M.vcf.gz \
  --all-sites true \
  --sample-ploidy 1
