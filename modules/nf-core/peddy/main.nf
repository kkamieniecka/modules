process PEDDY {
    tag "$meta.id"
    label 'process_low'

    conda 'modules/nf-core/peddy/environment.yml'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/peddy:0.4.8--pyh5e36f6f_0' :
        'biocontainers/peddy:0.4.8--pyh5e36f6f_0' }"

    input:
    tuple val(meta), path(vcf), path(vcf_tbi)
    path ped

    output:
    tuple val(meta), path("*.html")     , emit: html
    tuple val(meta), path("*.csv")      , emit: csv
    tuple val(meta), path("*.peddy.ped"), emit: ped
    tuple val(meta), path("*.png")      , optional: true, emit: png
    path "versions.yml"                 , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    peddy \\
        $args \\
        --prefix $prefix \\
        --plot \\
        -p $task.cpus \\
        $vcf \\
        $ped

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        peddy: \$( peddy --version 2>&1 | sed 's/peddy, version //' )
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.ped_check.csv
    touch ${prefix}.vs.html
    touch ${prefix}.het_check.csv
    touch ${prefix}.sex_check.csv
    touch ${prefix}.peddy.ped
    touch ${prefix}.html

    touch versions.yml
    """
}
