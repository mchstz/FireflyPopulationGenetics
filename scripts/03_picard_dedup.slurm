#!/bin/bash
#SBATCH --job-name=noc_dedup
#SBATCH --partition=krypton
#SBATCH --ntasks=1
#SBATCH --mem=32G
#SBATCH --array=1-67
#SBATCH -o logs/dedup_noc_%A_%a.out
#SBATCH -e err/dedup_noc_%A_%a.err

module load gnu python python-packages
module load picard samtools

SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" utils/sample_list.txt)

picard MarkDuplicates \
  I=02_alignments/Lanoc/${SAMPLE}_sorted.bam \
  O=03_dedup/Lanoc/${SAMPLE}_dedup.bam \
  M=03_dedup/Lanoc/${SAMPLE}_metrics.txt \
  REMOVE_DUPLICATES=true \
  VALIDATION_STRINGENCY=SILENT

samtools view -b -q 20 03_dedup/Lanoc/${SAMPLE}_dedup.bam \
  > 03_dedup/Lanoc/${SAMPLE}_dedup_q20.bam

samtools index 03_dedup/Lanoc/${SAMPLE}_dedup_q20.bam
