# FireflyPopulationGenetics
This is a pipeline to process and analyze whole genome sequencing data used in population genetics.
The `.fastq` files resulting from the sequencing process store information of the nucleotides and their respective quality scores.
There is two files for each individual, one for each DNA strand.

Additional Information can be found in my text.

I used `TrimGalore` to remove the nucleotide sequence of the Adapters that were added during the sequencing step, all base pairs that had a quality score lower than 20 and all fragments with a length of less than 20 basepairs.
https://www.trimgalore.com/guide/overview/

The first script `01_trim_galore` runs trim galore on all fastq files.
Flags:
`--illumina`; My sequences were sequenced using the Illumina sequencing process thats why I tell the program to specifically look for adapter sequences that are typically used in Illumina sequencing.
https://www.trimgalore.com/guide/adapters/
`--paired`; Runs a paired-end validation on both trimmed _1 and _2 FastQ files
`--quality`; sets the quality threshold
`--length`; sets the length threshold

The second script `02_bwa_map` adds IDs and sample names to know which fragments belong to unique samples.
It creates a string like: `@RG    ID:AuIn    SM:AuIn    PL:ILLUMINA` and attaches it to the corresponding `.bam`file.
https://gatk.broadinstitute.org/hc/en-us/articles/360035890671-Read-groups
The fragments are mapped to a reference genome using the `BWA` software package. 
This step requires a species specific reference genome `.fasta` file to which the fragments can be mapped against.
Such reference genomes for your species may be found at https://www.ncbi.nlm.nih.gov/.
The resulting `.bam`file format of this step corresponds to an alignment of the sequenced illumina DNA-fragments to our reference genome.

The next script `03_picard_dedup` uses the `MarkDuplicates`function of the software package `picard` on all the bam files.

This step removes optical duplicates.
Optical duplicates are artifacts arising from the sequencing process and we want to exclude them from the analysis.
https://gatk.broadinstitute.org/hc/en-us/articles/360037052812-MarkDuplicates-Picard
I set `REMOVE_DUPLICATES=true` to not write duplicates to the output file.
I set `VALIDATION_STRINGENCY=SILENT` to improve performance.


Additionally, this script performs a quality filtering step that relates to the alignment process.
Alignment sections include data about the mapping quality and we want to remove sections for which the alignment is ambiguous by removing all sections with a low quality score using the utility software package `samtools`.
`samtools`is a toolkit that can be used to perform fundamental operations on SAM/BAM/CRAM and BCF/VCF/gVCF files.
E.g. in this case, `samtools view -b -q 20 03_dedup/Lanoc/${SAMPLE}_dedup.bam \` loads all alignment sections in the bam file with a quality higher than 20 allowing us to save them to a new output.
Sometimes samtools will only work if the `htslib` module was also loaded.

In the next step we are going to identify individual Haplotypes and then global SNPs to produce the `VCF` file.
This is the most important file and it can be considered a checkpoint in the pipeline, consider storing it somewhere safe.

I am working on fireflies which have a XO-system (males are haploid on the X-Chromosome) and I extracted the alignment sections of the X-chromosome at the bam stage.
If your organism is diploid and you want to split your dataset into different subsets of genomic regions of interest it is easier to do this operation after generating the VCF file.
If your organism is haploid you have to be aware that the software used for calling Haplotypes and SNPs in this tutorial will artificially make haploid sequences diploid if not specified with the flag `--sample-ploidy 1`

To extract regions of interest from the bam files, script `03b_extract_ChrX` was used.
It requires a list of names of the contigs that make up the region of interest.



