#!/bin/bash
set -e
BASE_BUCKET="$AWS_BASE_BUCKET/nextflow-cli-example"

# Load the module
ml nextflow/19.07.0

nextflow \
    -C "./nextflow.aws.config" \
    run \
    main.nf \
    --param1 $BASE_BUCKET/data/test_in1 \
    --param2 $BASE_BUCKET/data/test_in2 \
    --param3 $BASE_BUCKET/data/test_in3 \
    -with-report output/nextflow_report.html \
    -work-dir $BASE_BUCKET/work/ \
    -resume
