#!/bin/bash
#$ -l highp,h_data=20G,h_rt=48:00:00,h_vmem=80G
#$ -pe shared 4
#$ -wd /u/home/1/1joeynik/project-rwayne/MYYU/JOH_paper/AssemblyReports_final/
#$ -o /u/home/1/1joeynik/project-rwayne/MYYU/JOH_paper/logs/step02_MYYU_NGXplot.out.txt
#$ -e /u/home/1/1joeynik/project-rwayne/MYYU/JOH_paper/logs/step02_MYYU_NGXplot.err.txt
#$ -m bae
#$ -N step02_MYYU_NGXplot

## Import Packages

source /u/home/1/1joeynik/project-rwayne/software/miniconda3/etc/profile.d/conda.sh
conda activate my_NGX

set -o pipefail

## Main

Rscript step02_MYYU_NGXplot.R

## Clean Up
echo -e "[$(date "+%Y-%m-%d %T")] Done"

conda deactivate

