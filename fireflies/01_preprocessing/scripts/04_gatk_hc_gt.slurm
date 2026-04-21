##submit as sbatch 01_preprocessing/scripts/04_gatk_hc

#!/bin/bash
#SBATCH --job-name=hc_noc
#SBATCH --partition=krypton
#SBATCH --ntasks=1
#SBATCH --mem=32G
#SBATCH --array=1-67
#SBATCH -o /01_preprocessing/logs/hc_noc_%A_%a.out
#SBATCH -e /01_preprocessing/err/hc_noc_%A_%a.err

module load gnu python python-packages
module load gatk

SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" utils/sample_list.txt)
REFERENCE="$utils/reference/*.fasta"
BAM_DIR="/01_preprocessing/03_dedup/"
OUT_DIR="/01_preprocessing/04_gatk/gvcf/"

mkdir -p "${OUTDIR}"

gatk HaplotypeCaller \
  -R ${REFERENCE} \
  -I ${BAM_DIR}/${SAMPLE}_dedup_q20.bam \
  -O ${OUTDIR}/${SAMPLE}.g.vcf.gz \
  -ERC GVCF

OUT_JOINT=$04_gatk/combined/combinedSpl.g.vcf.gz

mkdir -p "${OUT_JOINT}"

gatk CombineGVCFs \
  -R "${REFERENCE}
  $(for f in "$OUT_DIR"/Unknown_CS008-*.g.vcf.gz; do echo -V "$f"; done) \
  -O "$OUT_JOINT"

gatk GenotypeGVCFs \
  -R ${REFERENCE} \
  -V ${OUT_JOINT} \
  -O /04_gatk/${SPECIES}/Joint/${SPECIES}_SNPs_raw
