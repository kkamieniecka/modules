#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BEACON2RITOOLS } from '../../../../modules/nf-core/beacon2ritools/main.nf'

workflow test_beacon2ritools {
    
    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]

    BEACON2RITOOLS ( input )
}
