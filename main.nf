#!/usr/bin/env nextflow


/*
==============================================================================
                              wf-trim-asm-annot
==============================================================================
usage: nextflow run ./wf-trim-asm-annot/main.nf [-help]
----------------------------------------------------------------------------
*/

version = "1.0.0"
nextflow.enable.dsl=2

params.help = false
if (params.help){
    println "USAGE: put usage info here"
    exit 0
}
params.version = false
if (params.version){
    println "VERSION: $version"
    exit 0
}

// Default parameters
params.inpath = new File("${launchDir}").getCanonicalPath()
params.outpath = new File("${launchDir}").getCanonicalPath()
params.logpath = new File("${params.outpath}/.log").getCanonicalPath()

// Print parameters used
log.info """
         =====================================
         trim-asm-annot $version
         =====================================
         inpath:         ${params.inpath}
         outpath:        ${params.outpath}
         logpath:        ${params.logpath}
         =====================================
         """
         .stripIndent()

// Path handling
File inpathFileObj = new File(params.inpath)
if (!inpathFileObj.exists()){
    System.err.println "ERROR: $params.inpath doesn't exist"
    exit 1
}
File outpathFileObj = new File(params.outpath)
if (!outpathFileObj.exists()){
    outpathFileObj.mkdirs()
}
File logpathFileObj = new File(params.logpath)
if (logpathFileObj.exists()){
    System.out.println "WARNING: $params.logpath already exists. Log files will be overwritten."
} else {
    logpathFileObj.mkdirs()
}


/*
==============================================================================
                 Import local custom modules and subworkflows
==============================================================================
*/
include { FIND_INFILES; INFILE_HANDLING } from "./modules.nf"


/*
==============================================================================
                   Import nf-core modules and subworkflows
==============================================================================
*/
            //
            // none
            //

/*
==============================================================================
                            Run the main workflow
==============================================================================
*/
workflow {
    inp_ch = Channel.fromPath(params.inpath, checkIfExists: true)
    out_ch = Channel.fromPath(params.outpath, checkIfExists: true)

    FIND_INFILES(
        inp_ch
    )

    INFILE_HANDLING(
        FIND_INFILES.out.found_infiles,
        inp_ch
    )
}


/*
==============================================================================
                        Completion e-mail and summary
==============================================================================
*/
workflow.onComplete {
    workDir = new File("${workflow.workDir}")

    println """
    Pipeline Execution Summary
    --------------------------
    Workflow Version : ${workflow.version}
    Nextflow Version : ${nextflow.version}
    Command Line     : ${workflow.commandLine}
    Resumed          : ${workflow.resume}
    Completed At     : ${workflow.complete}
    Duration         : ${workflow.duration}
    Success          : ${workflow.success}
    Exit Code        : ${workflow.exitStatus}
    Error Report     : ${workflow.errorReport ?: '-'}
    Launch Dir       : ${workflow.launchDir}
    """
}

workflow.onError {
    def err_msg = """\
        Error summary
        ---------------------------
        Completed at: ${workflow.complete}
        exit status : ${workflow.exitStatus}
        workDir     : ${workflow.workDir}

        ??? extra error messages to include ???
        """
        .stripIndent()
/*    sendMail(
        to: "${USER}@cdc.gov",
        subject: 'workflow error',
        body: err_msg,
        charset: UTF-8
        // attach: '/path/stderr.log.txt'
    )
*/
}
