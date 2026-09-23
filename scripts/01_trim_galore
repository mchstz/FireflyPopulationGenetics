#!/bin/bash
#SBATCH --job-name=spl_trim_qc
#SBATCH --ntasks=1
#SBATCH --partition=krypton
#SBATCH --cpus-per-task=8
#SBATCH --nodes=1
#SBATCH --mem=16G
#SBATCH --array=1-52
#SBATCH -e err/trim_qc_spl%A_%a.err
#SBATCH -o out/trim_qc_spl%A_%a.out

module load gnu python python-packages
module load TrimGalore 
module load FastQC
module load samtools
module load cutadapt

OUTDIR=01_trimmed_reads/lamprohiza
RAW=00_raw_reads/lamprohiza

SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" sample_listSpl.txt)

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
