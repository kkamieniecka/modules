#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { PXF2BFF } from '../../../../modules/nf-core/beacon2ritools/pxf2bff/main.nf'

workflow test_pxf2bff {
    
    input = [
        [ id:'test' ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]

    PXF2BFF ( input )
}
