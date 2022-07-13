# Nextflow python CLI template 

An template repository for running a Python command line interface (CLI) using [Nextflow](https://www.nextflow.io/).

Nextflow is a tool for reproducible workflows using containers (e.g. Docker).
It allows running one's pipeline in a variety of ways, including on cloud services. 

This is a template repository containing the foundation of a Nextflow workflow for running commands from a Python-implemented CLI.
The hope is that this will be useful to those who already have a Python-implemented CLI, and would like to run it with lots of different combinations of parameters in an organized and scalable way.
[Here are the slides from my presentation](https://docs.google.com/presentation/d/1Hb3_cllkyxzuLvpV75yXn2xtKzYjXeT7C7SJvxmpFOs/edit?usp=sharing) describing Nextflow and this particular use case.

## Dependencies

You will need to have the following installed to run this project:

- [Nextflow](https://www.nextflow.io/docs/latest/getstarted.html#installation)
- [Python](https://www.python.org/downloads/)
- [Click](https://pypi.org/project/click/) 
- [Docker](https://www.docker.com/get-started)

## Building a workflow from the template

0. Write a Python CLI for your project (using [click](https://click.palletsprojects.com/) will make using this template easier).
1. [Create your own repo starting from the template](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template).
2. Add your CLI's commands to [scripts/cli.py](https://github.com/eharkins/nextflow-cli-example/blob/master/scripts/cli.py) (or replace it entirely if that suits you better).
3. Edit [main.nf](https://github.com/eharkins/nextflow-cli-example/blob/master/main.nf) to call your CLI appropriately.
4. Test by running [run_local.sh](https://github.com/eharkins/nextflow-cli-example/blob/master/run_local.sh) in an environment with dependencies installed.
5. Consult the [Nextflow documentation](https://www.nextflow.io/docs/latest/index.html) for making changes to the workflow code.


## Running on AWS Batch

Once you have completed the above steps and tested locally, to run the workflow on AWS Batch:

5. Set up [AWS Batch](https://aws.amazon.com/batch/) credentials (see below for doing this if you are at Fred Hutch) and fill them in to [run_aws.sh](https://github.com/eharkins/nextflow-cli-example/blob/master/run_aws.sh) and [nextflow.aws.config](https://github.com/eharkins/nextflow-cli-example/blob/master/nextflow.aws.config).
6. Test by running [run_aws.sh](https://github.com/eharkins/nextflow-cli-example/blob/master/run_aws.sh) in an environment with dependencies installed.

## Resources for use at Fred Hutch

- Follow the [instructions for setting up credentials for access to the Fred Hutch AWS account](https://sciwiki.fredhutch.org/scicomputing/access_credentials/#amazon-web-services-aws).
- When running on AWS Batch or using S3 storage, you will need to use your PI-specific S3 bucket as in these instructions
- You will need to email scicomp after setting up credentials to get the `jobRole` in [nextflow.aws.config](https://github.com/eharkins/nextflow-cli-example/blob/master/nextflow.aws.config).
- If you are working in the Matsen group at Fred Hutch, you can find [`$AWS_JOB_ROLE_ARN`](https://github.com/eharkins/nextflow-cli-example/blob/master/nextflow.aws.config) on the [Matsen group wiki](https://github.com/matsengrp/wiki/wiki/hutch_compute_resources#aws-batch) 

[Scientific Computing (scicomp) document regarding using Nextflow at the Hutch](https://sciwiki.fredhutch.org/compdemos/nextflow/)
