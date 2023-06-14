###########################################################################
###### R Script to Read in Genome Assembly Reports and Make NGX Plot#######
###########################################################################

# Author: Joey Curti 
# Revised from Script by: Meixi Lin
# Date: MON JUN 05 2023
# Version: 3


## Clean Workspace 

rm(list = ls())

## Dependencies 

library(dplyr)
library(ggplot2)
library(RColorBrewer)

#reference materials 
#https://github.com/meixilin/bobcat/blob/master/scripts/paper_assembly/figures/fig1d_ngx.R

# Cleanup 
rm(list = ls())
options(echo = TRUE, stringsAsFactors = FALSE)

# def functions
read_assemblyreport <- function(infile) {
  indt = read.delim(file = infile, comment.char = "#",
                    header = FALSE, stringsAsFactors = FALSE)
  # find colnames
  inlines = readLines(con = infile)
  headline = inlines[max(grep(pattern = '^#', x = inlines))]
  headnames = strsplit(sub('# ','',x=headline),split = '\t')[[1]]
  # replace `-` with `_`
  headnames = gsub(pattern = '-',replacement = '_',x = headnames)
  colnames(indt)=headnames
  return(indt)
}

get_cumsum <- function(indt) {
  # get sum length
  genomesize = sum(indt$Sequence_Length, na.rm=T)
  # sort by length
  outdt = indt %>%
    dplyr::arrange(desc(Sequence_Length))
  # get cumulative sum length
  cumsum = c()
  for (ii in 1:nrow(outdt)) {
    tempsum = sum(outdt$Sequence_Length[1:ii])
    cumsum = c(cumsum,tempsum)
  }
  outdt$Cumulative_Length = cumsum
  outdt$Cumulative_Coverage = outdt$Cumulative_Length/genomesize
  outdt = outdt[,c('Sequence_Length','Cumulative_Coverage','GenomeName','Assigned_Molecule')]
  outdt$Assigned_Molecule[outdt$Assigned_Molecule == 'na'] = NA_character_
  # add the starting positions
  startline = outdt[1,]
  startline$Cumulative_Coverage = 0
  outdt = rbind(startline, outdt)
  return(outdt)
}

# def variables --------

reportfiles1 = c("GCA_028536395.1_mMyoYum1.0.hap2_assembly_report.txt",
                  "GCF_000412655.1_ASM41265v1_assembly_report.txt",
                  "GCF_000147115.1_Myoluc2.0_assembly_report.txt",
                  "GCF_014108235.1_mMyoMyo1.p_assembly_report.txt",
                  "GCF_000327345.1_ASM32734v1_assembly_report.txt")
                  
names(reportfiles1) =c("mMyoYum1.0.hap2","ASM41265v1","Myoluc2.0","mMyoMyo1.p","ASM32734v1")


# load data --------
# load  reports
reportdtlist1 = lapply(reportfiles1, read_assemblyreport)

# add the genomename
for (ii in seq_along(reportdtlist1)){
  genomename = names(reportdtlist1)[ii]
  reportdtlist1[[ii]]$GenomeName = genomename
}

# the Sequence_Length attribute of the mMyoMyo1.p genome assembly report is a character, but it should be an integer. Let's fix that

reportdtlist1[[4]][9] <- as.integer(unlist(reportdtlist1[[4]][9]))

# main --------
# get cumulative sums
cumsumdtlist1 = lapply(reportdtlist1, get_cumsum)

plotdt1 = dplyr::bind_rows(cumsumdtlist1)

# plot the output ========

nb.cols <- 5
mycolors <- colorRampPalette(brewer.pal(8, "Paired"))(nb.cols)

pp <- ggplot(plotdt1,aes(x = Cumulative_Coverage, y = Sequence_Length/1e+6,
                        color = GenomeName)) +
  geom_step(direction = 'vh') +
  geom_vline(xintercept = 0.5, linetype = 'dashed') + 
  theme_bw() +
  theme(text = element_text(size = 12),
        axis.text = element_text(size = 12),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

# output files
ggsave(filename = paste0('fig1d_NGx_R',Sys.Date(),".pdf"), plot = pp, height = 10, width = 15)
