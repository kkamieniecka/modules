process PXF2BFF {
    tag "$meta.id"
    label 'process_low'

conda "bioconda::beacon2-ri-tools=2.0.0"
container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'beacon2ri/beacon_reference_implementation':
        'biocontainers/beacon2ri' }"

    input:
    
    tuple val(meta), path(json)

    output:
    tuple val(meta), path("*.bff"), emit: bff

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
   
    """
    pxf2bff -i <*.json> [-options] \\
        -i \\
        $args \\
        -@ $task.cpus \\
        -o ${prefix}.bff \\

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        : \$(echo \$(beacon2ritools --version 2>&1) | sed 's/^.*beacon2ritools //; s/Using.*\$//' ))
    END_VERSIONS
    """
