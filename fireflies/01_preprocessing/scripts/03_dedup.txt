###submit as sbatch 01_preprocessing/scripts/03_dedup

#!/bin/bash
#SBATCH --job-name=dedup
#SBATCH --partition=krypton
#SBATCH --ntasks=1
#SBATCH --mem=32G
#SBATCH --array=1-67
#SBATCH -o 01_preprocessing/logs/dedup_%A_%a.out
#SBATCH -e 01_preprocessing/err/dedup_%A_%a.err

module load gnu python python-packages
module load picard samtools

SPECIES="-" #insert either lampyris / lamprohiza

SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" 01_preprocessing/utils/sample_list${SPECIES}.txt)
ALIGNMENTS="$01_preprocessing/02_alignments/"
OUTDIR="/01_preprocessing/03_dedup/"

mkdir -p {OUTDIR}

picard MarkDuplicates \
  I=${ALIGNMENTS}/${SAMPLE}_sorted.bam \
  O={OUTDIR}/${SAMPLE}_dedup.bam \
  M={OUTDIR}/${SAMPLE}_metrics.txt \
  REMOVE_DUPLICATES=true \
  VALIDATION_STRINGENCY=SILENT

samtools view -b -q 20 dedup/${SAMPLE}_dedup.bam \
  > dedup/${SAMPLE}_dedup_q20.bam

samtools index dedup/${SAMPLE}_dedup_q20.bam
