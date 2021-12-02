# Nfconsensus - nextflow pipeline creating consensus sequences from bam files 

This pipelines creates consensus sequences for whole scaffolds from bam files using angsd and outputs them in gzipped fasta format. 

Steps of the pipeline are: 

1. Indexing of bam files.
2. Reducing bam file to only that region for which the consensus should be created.
3. Calling the consensus using angsd's [doFasta](http://www.popgen.dk/angsd/index.php/Fasta) algorithm using the majority rule (consensus, -doFasta 2 ) criterium.
4. Adds the sample and scaffold name to the fasta header.



## Usage

```bash
nextflow run consensus.nf --bamdir /PATH/TO/BAMS/ --outdir /PATH/TO/DIR/TO/PUT/OUTPUT/ --scaf NAME --mindepth INT
```

**Parameters:**

* --bamdir : Path to directory in with sub folders for each individual. Each sub folder must hold one bam file.
* --outdir : Path to directory were the output of the pipeline will be written into.
* --scaf : The name of the scaffold or region for which the consensus should be called. F.e. "chrM" for the mitogenome is chrM is the name of the scaffold that holds the mitogenome, or "chrM:1-10" for only the first ten position of the mitogenome. 
* --mindepth: The minimum depth at which the a base should be determined as consensus following the majority rule. 



**Output:**

The pipeline will write one gzipped fasta file per sample into the output directory. 
