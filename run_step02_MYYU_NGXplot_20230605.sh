#!/bin/bash
#$ -l highp,h_data=20G,h_rt=48:00:00,h_vmem=80G
#$ -pe shared 4
#$ -wd /u/home/1/1joeynik/project-rwayne/MYYU/JOH_paper/AssemblyReports_final/
#$ -o /u/home/1/1joeynik/project-rwayne/MYYU/JOH_paper/logs/step02_MYYU_NGXplot_20230605.out.txt
#$ -e /u/home/1/1joeynik/project-rwayne/MYYU/JOH_paper/logs/step02_MYYU_NGXplot_20230605.err.txt
#$ -m bae
#$ -M 1joeynik
#$ -N step02_MYYU_NGXplot_20230605

## Import Packages

source /u/home/1/1joeynik/project-rwayne/software/miniconda3/etc/profile.d/conda.sh
conda activate my_NGX

set -o pipefail

## Main

Rscript step02_MYYU_NGXplot_20230605.R

## Clean Up
echo -e "[$(date "+%Y-%m-%d %T")] Done"

conda deactivate

