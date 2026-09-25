#!/bin/bash
#SBATCH --job-name=noc_extract_ChrX_BAM
#SBATCH --ntasks=1
#SBATCH --partition=krypton
#SBATCH --cpus-per-task=4
#SBATCH --nodes=1
#SBATCH --mem=16G
#SBATCH -e 03_dedup/err/extract_chrX_bam.err
#SBATCH -o 03_dedup/logs/extract_chrX_bam.log

module load gnu python python-packages
module load htslib
module load samtools

BAMDIR=03_dedup/Lanoc
OUT=03_dedup/Lanoc/ChrX

mkdir -p "$OUT"

CHR_LIST=(
scf7180000016957
scf7180000016988
scf7180000017002
scf7180000017011
scf7180000017177
scf7180000017225
scf7180000017251
scf7180000017290
scf7180000017403
scf7180000017668
scf7180000017739
scf7180000017840
scf7180000017942
scf7180000017974
scf7180000018141
scf7180000018783
scf7180000018862
scf7180000019276
scf7180000019327
scf7180000019386
scf7180000019818
scf7180000020876
scf7180000021800
scf7180000023414
scf7180000023510
scf7180000023545
scf7180000023655
scf7180000023685
scf7180000023780
scf7180000023833
scf7180000024358
scf7180000024366
scf7180000024428
scf7180000024429
scf7180000021655_F__4230_scf7180000021922_F
)

for BAM in "$BAMDIR"/*.bam; do
    SAMPLE=$(basename "$BAM" .bam)

    # input BAM must be indexed
    if [ ! -f "${BAM}.bai" ]; then
        samtools index -@ 4 "$BAM"
    fi

    samtools view -@ 4 -b "$BAM" "${CHR_LIST[@]}" \
        -o "$OUT/${SAMPLE}_ChrX.bam"

    samtools index -@ 4 "$OUT/${SAMPLE}_ChrX.bam"
done
