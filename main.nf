#!/usr/bin/env nextflow

params.outdir = "$baseDir/output/"
params.dryRun = false

println params
if( params.dryRun ){
    dryFlag = '--dry'
    outdir = params.outdir + '/.dry/'
} 
else {
    dryFlag = ''
    outdir = params.outdir
}

/*
 * this assumes params will be in plain text files (one for each parameter) with each value on a new line 
 * it may make more sense eventually to have all parameters in a JSON file and parse that here so that 
 * the file on its own makes more sense.
 */
channel1 = Channel.fromPath(params.param1).splitText().map{ it -> it.trim() }
channel2 = Channel.fromPath(params.param2).splitText().map{ it -> it.trim() }
channel3 = Channel.fromPath(params.param3).splitText().map{ it -> it.trim() }

/*
 * do this process for all combinations of the 3 parameters
 */
process pythoncli {
    container "docker.pkg.github.com/eharkins/nextflow-cli-template/nextflow-example:latest"

// uncomment to echo std out from each command run by nextflow, otherwise it will be ignored
    echo true

    input:
    each var1 from channel1
    each var2 from channel2
    each var3 from channel3

    output:
    file "output1.${var1}.${var2}.${var3}.txt"
    file "output2.${var1}.${var2}.${var3}.txt"
    file "output3.${var1}.${var2}.${var3}.txt"

    publishDir "${outdir}"

    """
    cli.py ${dryFlag} command1 --option1 ${var1} --option2 ${var2} --option3 ${var3}
    """
}
