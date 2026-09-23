#!/bin/bash
#SBATCH --job-name=noc_bwa
#SBATCH --partition=krypton
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --array=1-67
#SBATCH -o logs/bwa_noc_%A_%a.out
#SBATCH -e err/bwa_noc_%A_%a.err

module load gnu python python-packages
module load bwa samtools

SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" utils/sample_list.txt)

RG="@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tPL:ILLUMINA"

bwa mem -t 8 \
  -R "${RG}" \
  reference/Lanoc/lanoc_primary_curatedPurged_wMito.fasta \
  01_trimmed_reads/Lanoc/${SAMPLE}_1_val_1.fq.gz \
  01_trimmed_reads/Lanoc/${SAMPLE}_2_val_2.fq.gz | \
samtools view -Sb - > 02_alignments/Lanoc/${SAMPLE}.bam

samtools sort -o alignments/Lanoc/${SAMPLE}_sorted.bam alignments/Lanoc/${SAMPLE}.bam
samtools index alignments/Lanoc/${SAMPLE}_sorted.bam
rm alignments/Lanoc/${SAMPLE}.bam
