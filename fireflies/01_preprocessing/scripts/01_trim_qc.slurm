###submit as sbatch 01_preprocessing/scripts/01_trimQC.slurm

#!/bin/bash
#SBATCH --job-name=trim_qc_noc
#SBATCH --ntasks=1
#SBATCH --partition=krypton
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1
#SBATCH --mem=32G
#SBATCH --array=1-119
#SBATCH -e /home/mstrehl/fireflies/err/trim_qc_noc%A_%a.err
#SBATCH -o /home/mstrehl/fireflies/out/trim_qc_noc%A_%a.out

module load gnu python python-packages
module load TrimGalore 
module load FastQC
module load samtools
module load cutadapt

OUTDIR=/home/mstrehl/fireflies/01_preprocessing/01_trimmed_reads
RAW=/home/mstrehl/fireflies/00_raw_reads

SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /utils/sample_list.txt)

trim_galore \
--illumina \
--paired \
--quality 20 \
--length 20 \
--fastqc \
--cores 8 \
-O ${OUTDIR} \
${RAW}/${SAMPLE}_1.fq.gz \
${RAW}/${SAMPLE}_2.fq.gz
