#!/usr/bin/env nextflow
log.info """\
         Fancy nextflow consensus creater
         ===================================
         Bam directory           : ${params.bamdir}
         Output directory        : ${params.outdir}
         Region or scaffold      : ${params.scaf}
         Min Depth               : ${params.mindepth}
         """
         .stripIndent()

 // holds the individual bam files
 Channel
   .fromPath("${params.bamdir}*/*.bam")
   .set{bam_ch}

process IndexBAM {
  input:
  file(bam) from bam_ch

  output:
  tuple file(bam), file('*.bai') into bambai_ch

  script:
  """
  samtools index $bam
  """
}

process GetRegion {
  input:
  tuple file(bam), file(bai) from bambai_ch

  output:
  file('*.bam') into regbam_ch

  script:
  """
  samtools view -h -X $bam $bai ${params.scaf} > ${bam.baseName}_${params.scaf}.bam
  """
}

process CreateConsensus {

  publishDir "${params.outdir}", mode: 'copy'

  input:
  file(bam) from regbam_ch

  output:
  file('*.fa.gz')

  script:
  """
  angsd -doFasta 2 -doCounts 1 -setMinDepth ${params.mindepth} -i $bam -out ${bam.baseName}
  """
}
