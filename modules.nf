nextflow.enable.dsl = 2


process FIND_INFILES {

    input:
        path(input_path)

    output:
        path("find_infiles.success.txt"), emit: found_infiles

    script:
    """
    find_infiles.sh ${input_path}
    cat .command.out >> ${params.logpath}/stdout.nextflow.txt
    cat .command.err >> ${params.logpath}/stderr.nextflow.txt
    """

    stub:
    """
    touch find_infiles.success.txt
    """

}


process INFILE_HANDLING {

    input:
        path(found_infiles)
        path(input_dir_path)

    output:
        path("infile_handling.success.txt"), emit: handled_infiles

    script:
    """
    infile_handling.sh ${input_dir_path}
    cat .command.out >> ${params.logpath}/stdout.nextflow.txt
    cat .command.err >> ${params.logpath}/stderr.nextflow.txt
    """

    stub:
    """
    touch infile_handling.success.txt
    """

}