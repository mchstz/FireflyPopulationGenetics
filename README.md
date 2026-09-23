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
