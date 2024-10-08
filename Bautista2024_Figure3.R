#Main Figures of the Manuscript Bautista_2024

##Figure 3###

#In order to place the figures in the same folder as the data tables,
#you need to specify the name of this directory in the 'Set Directory' section below.

####Packages####
rm(list=ls())
#install.packages("agricolae")
library(agricolae)
#if (!require("BiocManager", quietly = TRUE))
#install.packages("BiocManager")
library(BiocManager)
#install.packages("broom")
library(broom)
#install.packages("car",type="binary")
library(car)
#install.packages("cowplot")
library(cowplot)
#install.packages("data.table")
library(data.table)
#install.packages("dplyr")
library(dplyr)
#install.packages("drc")
library(drc)
#install.packages("egg")
library(egg)
#install.packages("factoextra")
library(factoextra)
#install.packages("foreign")
library(foreign)
#install.packages("flowCore")
library(flowCore)
#install.packages("flowViz")
library(flowViz)
#install.packages("gdata")
library(gdata)
#install.packages("ggimage")
library(ggimage)
#install.packages("ggsignif")
library(ggsignif)
#install.packages("ggtext")
library(ggtext)
#install.packages("ggplot2")
library(ggplot2)
#install.packages("ggprism")
library(ggprism)
#install.packages("grid")
library(ggpubr)
#install.packages("ggthemes")
library(ggthemes)
#install.packages("glue")
library(glue)
#install.packages("grid")
library(grid)
#install.packages("gridExtra")
library(gridExtra)
#install.packages("growthcurver") 
library(growthcurver)
#install.packages("gtable")
library(gtable)
#install.packages("janitor")
library(janitor)
#install.packages("lme4",type="binary")
library(lme4)
#install.packages("magick")
library(magick)
#install.packages("magrittr")
library(magrittr)
#install.packages("Matrix") 
library(Matrix)
#install.packages("modelr")
library(modelr)
#install.packages("multcomp")
library(multcomp)
#install.packages("multcompView")
library(multcompView)
#install.packages("nlme") 
library(nlme)
#install.packages("pegas")
library(pegas)
#install.packages("png")
library(png)
#install.packages("quantreg", type="binary")
library(quantreg)
#install.packages("readr")
library(readr)
#install.packages("readxl")
library(readxl)
#install.packages("reshape2")
library(reshape2)
#install.packages("rstatix")
library(rstatix)
#install.packages("stats")
library(stats)
#install.packages("stringr")
library(stringr)
#install.packages("svglite")
library(svglite)
#install.packages("tidyr")
library(tidyr)
#install.packages("tidyverse")
library(tidyverse)
#install.packages("UpSetR")
library(UpSetR)
#BiocManager::install("VariantAnnotation")
library(VariantAnnotation)
#install.packages("vcfR")
library(vcfR)
#################

####Set directory####
#Define the directory where you save all the data from Bautista_2024
setwd("")
#################

####Define some functions####
toexpr<-function(x) {
  getfun <- function(x) {
    ifelse(x=="Hybrid", "plain", "italic")
  }
  as.expression(unname(Map(function(f,v) substitute(f(v), list(f=as.name(f), v=as.character(v))), getfun(x), x)))
}
#################

#####1.Get data#####
A_Table_counts_SNPs <- read.csv("3A_Table_SNPs.csv")
genomics <- read_csv("3_growth.csv")
my_data <- read_excel("3CDE_Table_SNPs_PDR1.xlsx")
my_data2 <- read_excel("3CDE_Table_SNPs_PDR1_data.xlsx")
#################


############Figure 3A############
#Some data transformations
all2<-A_Table_counts_SNPs

#remove hybrids
all2_h<-all2%>%filter(Strain!="3Hybrid")


all2_h2<-all2%>%filter(Strain=="3Hybrid")

all2_h2_control<-all2_h2%>%filter(condition!="NQO")

all2_h2_nqo<-all2_h2%>%filter(condition=="NQO")
all2_h2_nqo<-all2_h2_nqo%>%filter(Replicate!=1)
all2_h2_nqo<-all2_h2_nqo%>%filter(Replicate!=10)
all2_h2_nqo<-all2_h2_nqo%>%filter(Replicate!=21)
all2_h2_nqo<-all2_h2_nqo%>%filter(Replicate!=25)

all3<-rbind(all2_h,all2_h2_control,all2_h2_nqo)
all2<-all3
#Counts per Line
rows.per.group  <- aggregate(rep(1, length(paste0(all2$Strain, all2$condition,all2$ensembl_gene_id,all2$Replicate))),
                             by=list(all2$Strain, all2$condition,all2$ensembl_gene_id,all2$Replicate,all2$GENENAME), sum)
colnames(rows.per.group) <- c("Strain","Type","ensembl_gene_id","Replicate","Genename","Counts")

#Counts per Line and Gene
all2<-rows.per.group
rows.per.group2  <- aggregate(rep(1, length(paste0(all2$Strain, all2$Type,all2$ensembl_gene_id))),
                              by=list(all2$Strain, all2$Type,all2$ensembl_gene_id,all2$Genename), sum)
colnames(rows.per.group2) <- c("Strain","Type","ensembl_gene_id","Genename","Counts")

#Transformations for the panel A
all_data3 <-dplyr::filter(rows.per.group2,Counts>2)

nqo<-all_data3 %>% dplyr::filter(Type=="NQO")

#Panel A
legend_title <- "Genotype"

Fig3A<-nqo %>%
  ggplot(aes(x=reorder(Genename, -Counts),y=Counts,fill=Strain)) +
  geom_bar(stat='identity',
           width = 0.9, color = "black", alpha = 0.7) +
  xlab("Gene")+ylab("Count")+
  scale_fill_manual(legend_title,values=c("green4", "dodgerblue1", "#FF9999"), 
                    labels = toexpr(c("S. cerevisiae", "S. paradoxus", "Hybrid")))+
  theme_light()+
  background_grid(
    major = c("xy"),
    minor = c("y"),
    size.major = 0.5,
    size.minor = 0.3,
    color.major = "grey85",
    color.minor = "grey85") +
  scale_x_discrete(limits=c("PDR1","YRR1","FKS1","IRA1","FLO1","ADY3","MAL31"))+
  geom_text(aes(label = Counts), position = position_stack(vjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1,size = 14, color="black",face = "bold"),
        axis.text.y = element_text(size = 14, color="black"),
        axis.title = element_text(size = 15,face="bold"))+
  theme(axis.text.x = element_text(face = "italic")) +
  theme(legend.position="none")+
  theme(legend.position = "bottom",
        legend.direction = "horizontal",
        legend.text = element_text(size=16),
        legend.title = element_text(size=16))

legheatmap0 <- get_legend(Fig3A)

Fig3A<-nqo %>%
  ggplot(aes(x=reorder(Genename, -Counts),y=Counts,fill=Strain)) +
  geom_bar(stat='identity',
           width = 0.9, color = "black", alpha = 0.7) +
  xlab("Gene")+ylab("Count")+
  scale_fill_manual(legend_title,values=c("green4", "dodgerblue1", "#FF9999"), 
                    labels = toexpr(c("S. cerevisiae", "S. paradoxus", "Hybrid")))+
  theme_light()+
  background_grid(
    major = c("xy"),
    minor = c("y"),
    size.major = 0.5,
    size.minor = 0.3,
    color.major = "grey85",
    color.minor = "grey85") +
  scale_x_discrete(limits=c("PDR1","YRR1","FKS1","IRA1","FLO1","ADY3","MAL31"))+
  geom_text(aes(label = Counts), position = position_stack(vjust = 0.5)) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1,size = 12, color="black",face = "bold"),
        axis.text.y = element_text(size = 12, color="black"),
        axis.title = element_text(size = 13,face="bold"),
        axis.title.y = element_text(size = 12,face="bold"))+
  theme(axis.text.x = element_text(face = "italic")) +
  theme(legend.position="none")
#################

############Figure 3B############
img <- readPNG("Figure3B.png")
gpp <- rasterGrob(img, interpolate=TRUE)
Fig3B<-plot_grid(gpp)
#################

############Figure 3C############

######Get fitness %######
genomics1 <- dplyr:::filter(genomics,condition=="NQO")
genomics1 <- dplyr:::filter(genomics1,day==2)
genomics1$Replicate<-as.numeric(genomics1$Replicate)
genomics2<-genomics1 %>% dplyr:::filter(Evolved=="Evolved_NQO")
genomics1 <- dplyr:::filter(genomics,condition=="NQO")
genomics1 <- dplyr:::filter(genomics1,day==2)
genomics1$Replicate<-as.numeric(genomics1$Replicate)
genomics3<-genomics1 %>% dplyr:::filter(Evolved=="Ancestor")

genomics4<- left_join(genomics2,genomics3, by=c("Specie"="Specie","condition"="condition","Replicate"="Replicate"))

genomics4$fitness_gain<- (genomics4$rval.x - genomics4$rval.y) / genomics4$rval.y
genomics4$percentage <- genomics4$fitness_gain * 100
######
######Hybrid heatmap######
#Remove replicate line from mutation G279R in hybrid as line 24 have two mutations, so I have Mutation_4 with the info of the two mutations
my_data <- filter(my_data,Mutation_3!="P298R")
my_data_hyb <- filter(my_data,Strain=="3Hybrid")

my_data_try <- filter(my_data,Mutation_3=="G279R")

order_mutations <- c("P298R \n", "\nG279R")

my_data_trya<-rbind(my_data_try,my_data_try)

#divide:
my_data <- filter(my_data,Mutation_3!="P298R")
my_data_hyb <- filter(my_data,Strain=="3Hybrid")

my_data_hyb <- filter(my_data_hyb,Mutation_3!="G279R")
my_data_hyb <- filter(my_data_hyb,Mutation_3!="G282R")
my_data_hyb <- filter(my_data_hyb,Mutation_3!="R820H")
my_data_tryb <- filter(my_data_hyb,Mutation_3!="M308I")

my_data <- filter(my_data,Mutation_3!="P298R")
my_data_hyb <- filter(my_data,Strain=="3Hybrid")

my_data_hyb <- filter(my_data_hyb,Mutation_3!="G279R")
my_data_hyb <- filter(my_data_hyb,Mutation_3!="E1045V")
my_data_hyb <- filter(my_data_hyb,Mutation_3!="V1047F")
my_data_tryc <- filter(my_data_hyb,Mutation_3!="D516H")

order_mutations <- c("P298R \n", "\nG279R","E1045V","V1047F","D516H","M308I","R820H","G282R","M308I")

my_data_hybtry3<-rbind(my_data_trya,my_data_tryb,my_data_tryc)
heatmap_hyb1<- ggplot(my_data_hybtry3, aes(x=as.character(Replicate),
                                       y="Protein position",col=order_mutations))+ 
  geom_tile(linewidth=0.5, fill="white") +
  geom_text(aes(label=order_mutations),size=2.5)+
  scale_y_discrete(labels=c(expression(bold("Protein position     "))))+
  scale_color_manual(values=c("turquoise4","gray4","gray4","chocolate4","mediumorchid3",
                              "gray4","gray4","gray4"))+
  ylab(" ") + xlab("Line")+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+
  theme(legend.position = "none")+
  theme(axis.ticks.y=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'white'))+
  theme(plot.background = element_rect(fill = 'white', colour = 'white'))+
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())

order_mutations <- c("P298R \n", "\nG279R","E1045V","V1047F","D516H","M308I","R820H","G282R","M308I")

my_data_hybtry3$order <- c(10,9,6,2,3,4,5,7,1)
my_data_hybtry3$order<-as.numeric(my_data_hybtry3$order)

heatmap_hyb1<- ggplot(my_data_hybtry3,aes(x = factor(Replicate, levels = unique(Replicate[order(-order)])), 
                                           y="Protein position",col=order_mutations))+ 
  geom_tile(linewidth=0.5, fill="white") +
  geom_text(aes(label=order_mutations),size=2.5)+
  scale_y_discrete(labels=c(expression(bold("Protein position     "))))+
  scale_color_manual(values=c("turquoise4","gray4","gray4","chocolate4","mediumorchid3",
                              "gray4","gray4","gray4"))+
  ylab(" ") + xlab("Line")+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+
  theme(legend.position = "none")+
  theme(axis.ticks.y=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'white'))+
  theme(plot.background = element_rect(fill = 'white', colour = 'white'))+
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())

genomics4_hyb<-filter(genomics4, Specie=="3Hybrid")
rephyb<-filter(genomics4_hyb, Replicate==2)
rephyc<-filter(genomics4_hyb, Replicate==24)
rephyd<-filter(genomics4_hyb, Replicate==17)
rephye<-filter(genomics4_hyb, Replicate==27)
rephyf<-filter(genomics4_hyb, Replicate==30)
rephyg<-filter(genomics4_hyb, Replicate==9)
rephyh<-filter(genomics4_hyb, Replicate==13)
rephyi<-filter(genomics4_hyb, Replicate==28)

rep_fitness<- rbind(rephyb,rephyc,rephyd,rephye,rephyf,rephyg,rephyh,rephyi)
 
legend_title <- "Increase in growth rate (%)"
heatmap_hyb2<- ggplot(rep_fitness, aes(x = factor(Replicate, levels = unique(Replicate[order(fitness_gain)])), 
                                       y="percentage"))+ 
  scale_fill_gradientn(legend_title,colours = c("lavender", "midnightblue"),na.value="white",limits = c(0,200)) +
  scale_y_discrete(labels=c(expression(bold("Increase in growth rate (%)"))))+
  geom_tile(linewidth=0.5, aes(fill=fitness_gain),col="black") +
  theme(panel.background = element_rect(fill = 'white', colour = 'white'))+
  theme(plot.background = element_rect(fill = 'white', colour = 'white'))+
  ylab(" ") + xlab("Hybrid lines") +
  theme(axis.ticks.y=element_blank())+
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())+
  theme(legend.position = "bottom",
        legend.direction = "horizontal")+
  theme(legend.title = element_text(size=14),
        legend.text = element_text(size=11))+
  theme(axis.text.x = element_text(size=11))+
  geom_text(aes(label=round(fitness_gain, digits = 2)),col="white")

legheatmap2 <- get_legend(heatmap_hyb2)

heatmap_hyb2<- ggplot(rep_fitness, aes(x = factor(Replicate, levels = unique(Replicate[order(fitness_gain)])), 
                                       y="Fitness_gain"))+ 
  scale_fill_gradientn(legend_title,colours = c("lavender", "midnightblue"),na.value="white",limits = c(-0.2,2)) +
  scale_y_discrete(labels=c(expression(bold("Increase in growth rate (%)"))))+
  geom_tile(linewidth=0.5, aes(fill=fitness_gain),col="black") +
  theme(panel.background = element_rect(fill = 'white', colour = 'white'))+
  theme(plot.background = element_rect(fill = 'white', colour = 'white'))+
  ylab(" ") + xlab("Hybrid lines") +
  theme(axis.ticks.y=element_blank())+
  theme(legend.position = "none")+
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())+
  theme(axis.text.x = element_text(size=11))+
  geom_text(aes(label=round(percentage, digits = 0)),col="white")

hyb_plot<- plot_grid(heatmap_hyb1,NULL,
                     heatmap_hyb2, ncol=1,rel_heights = c(1,-0.21,1,-0.21,1.35))  

######
######S.cerevisiae heatmap######
my_data_scer <- filter(my_data,Strain=="1Scer")

heatmap_scer1<- ggplot(my_data_scer, aes(x=as.character(Replicate),
                                       y="Protein position",col=Mutation_4))+ 
  geom_tile(linewidth=0.5, fill="white") +
  scale_color_manual(values=c("slateblue","chocolate4","gray4"))+
  geom_text(aes(label=Mutation_4), size=2.5)+
  scale_y_discrete(labels=c(expression(bold("Amino acid change"))))+
  ylab(" ") + xlab("Line")+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+
  theme(legend.position = "none")+
  theme(axis.ticks.y=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'white'))+
  theme(plot.background = element_rect(fill = 'white', colour = 'white'))

genomics4_spar<-filter(genomics4, Specie=="1Scer")
rephyb<-filter(genomics4_spar, Replicate==2)
rephyc<-filter(genomics4_spar, Replicate==25)
rephyd<-filter(genomics4_spar, Replicate==27)

rep_fitness<- rbind(rephyb,rephyc,rephyd)

heatmap_scer2<- ggplot(rep_fitness, aes(x=as.character(Replicate),
                                       y="percentage"))+ 
  scale_fill_gradientn(legend_title,colours = c("lavender", "midnightblue"),na.value="white",limits = c(-0.2,2)) +
  scale_y_discrete(labels=c(expression(bold("        Increase in  \n       growth rate (%)"))))+
  geom_tile(linewidth=0.5, aes(fill=fitness_gain),col="black") +
  theme(panel.background = element_rect(fill = 'white', colour = 'white'))+
  theme(plot.background = element_rect(fill = 'white', colour = 'white'))+
  ylab(" ") + xlab(expression(paste(italic("S.cerevisiae"), " lines"))) +
  theme(axis.ticks.y=element_blank())+
  theme(legend.position = "none")+
  theme(axis.text.x = element_text(size=11))+
  geom_text(aes(label=round(percentage, digits = 0)),col="white")

scer_plot<- plot_grid(heatmap_scer1,NULL,
                     heatmap_scer2, ncol=1,rel_heights = c(1,-0.21,1,-0.21,1.35))  
######
######S.paradoxus heatmap######
my_data_spar <- filter(my_data,Strain=="2Spar")

my_data_spar$order <- c(1,8,2,7,3,5,4,6)
my_data_spar$order<-as.numeric(my_data_spar$order)

heatmap_spar1<- ggplot(my_data_spar, aes(x = factor(Replicate, levels = unique(Replicate[order(-order)])), 
                                         y="Protein position",col=Mutation_4))+ 
  scale_color_manual(values=c("gray4","gray4","slateblue","turquoise4","gray4","mediumorchid3","mediumorchid3","gray4"))+
  geom_tile(linewidth=0.5, fill="white") +
  geom_text(aes(label=Mutation_4),size=2.5)+
  scale_y_discrete(labels=c(expression(bold("Protein position     "))))+
  ylab(" ") + xlab("Line")+
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+
  theme(legend.position = "none")+
  theme(axis.ticks.y=element_blank())+
  theme(panel.background = element_rect(fill = 'white', colour = 'white'))+
  theme(plot.background = element_rect(fill = 'white', colour = 'white'))+
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())

genomics4_spar<-filter(genomics4, Specie=="2Spar")
rephyb<-filter(genomics4_spar, Replicate==24)
rephyc<-filter(genomics4_spar, Replicate==4)
rephyd<-filter(genomics4_spar, Replicate==9)
rephye<-filter(genomics4_spar, Replicate==17)
rephyf<-filter(genomics4_spar, Replicate==27)
rephyg<-filter(genomics4_spar, Replicate==22)
rephyh<-filter(genomics4_spar, Replicate==28)
rephyi<-filter(genomics4_spar, Replicate==29)

rep_fitness<- rbind(rephyb,rephyc,rephyd,rephye,rephyf,rephyg,rephyh,rephyi)

heatmap_spar2<- ggplot(rep_fitness, aes(x = factor(Replicate, levels = unique(Replicate[order(fitness_gain)])),
                                       y="percentage"))+ 
  scale_fill_gradientn(legend_title,colours = c("lavender", "midnightblue"),na.value="white",limits = c(-0.2,2)) +
  scale_y_discrete(labels=c(expression(bold("Increase in growth rate (%)"))))+
  geom_tile(linewidth=0.5, aes(fill=fitness_gain),col="black") +
  theme(panel.background = element_rect(fill = 'white', colour = 'white'))+
  theme(plot.background = element_rect(fill = 'white', colour = 'white'))+
  xlab(expression(paste(italic("S.paradoxus"), " lines"))) +
  ylab(" ") + 
  theme(axis.ticks.y=element_blank())+
  theme(legend.position = "none")+
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank())+
  theme(axis.text.x = element_text(size=11))+
  geom_text(aes(label=round(percentage, digits = 0)),col="white")

spar_plot<- plot_grid(heatmap_spar1,NULL,
                     heatmap_spar2, ncol=1,rel_heights = c(1,-0.21,1,-0.21,1.35))  
########
Figure3C<- plot_grid(scer_plot,spar_plot,hyb_plot,nrow=1,rel_widths = c(1.1,1.7,1.7))

img <-image_read_pdf("Figure3C.pdf")
gpp <- rasterGrob(img, interpolate = TRUE)
Fig3C <- plot_grid(gpp)

Figure3C_cartoon<-plot_grid(Fig3C,Figure3C,nrow=2, rel_heights = c(0.3,1))

Fig3C<- plot_grid(legheatmap2,Figure3C_cartoon,nrow=2,rel_heights= c(0.2,0.8))
#################

############Figure 3D############
genomics1 <- dplyr:::filter(genomics,condition=="NQO")
genomics1 <- dplyr:::filter(genomics1,day==2)
genomics1$Replicate<-as.numeric(genomics1$Replicate)
genomics2<-genomics1 %>% dplyr:::filter(Evolved=="Evolved_NQO")
genomics1 <- dplyr:::filter(genomics,condition=="NQO")
genomics1 <- dplyr:::filter(genomics1,day==2)
genomics1$Replicate<-as.numeric(genomics1$Replicate)
genomics3<-genomics1 %>% dplyr:::filter(Evolved=="Ancestor")

genomics4<- left_join(genomics2,genomics3, by=c("Specie"="Specie","condition"="condition","Replicate"="Replicate"))

genomics4$fitness_gain<- (genomics4$rval.x - genomics4$rval.y) / genomics4$rval.y
genomics4$percentage <- genomics4$fitness_gain * 100

fitness_PDR_events <-left_join(my_data2,genomics4, by=c("Strain"="Specie",
                                                       "Replicate2"="Replicate"))
toexpr<-function(x) {
  getfun <- function(x) {
    ifelse(x=="Hybrid", "plain", "italic")
  }
  as.expression(unname(Map(function(f,v) substitute(f(v), list(f=as.name(f), v=as.character(v))), getfun(x), x)))
}

my_y_title <- expression(paste(bold("Number of "), bolditalic("PDR1"), bold(" mutated copies")))

fitness_PDR_events$mutation_strain <- paste(fitness_PDR_events$Type_mutation, fitness_PDR_events$Strain)
fitness_PDR_events$mutation_strain <- as.factor(fitness_PDR_events$mutation_strain)

result_kruskal <- kruskal.test(percentage ~ mutation_strain, data = fitness_PDR_events)
kruskal_cld <- kruskal(fitness_PDR_events$percentage, fitness_PDR_events$mutation_strain, group=TRUE, p.adj="BH")$groups
cld <- as.data.frame(kruskal_cld)
cld

Figure3D <- fitness_PDR_events %>%
  ggplot(aes(x=interaction(Type_mutation,Strain),y = percentage))+
  geom_boxplot(aes(fill=Strain,alpha=0.3))+
  geom_point(colour="black",pch=21,size=2, aes(fill=Strain))+
  theme(legend.position = "top") + 
  theme(strip.text = element_text(face = "bold", size = 9),
    strip.background = element_blank())+
  geom_vline(xintercept=c(1.5,4.5))+
  scale_fill_manual(values=c("green4", "dodgerblue1", "#FF9999"), 
                    labels = toexpr(c("S. cerevisiae", "S. paradoxus", "Hybrid")))+
  scale_x_discrete(limits=c("Homozygous.1Scer",
                            "Homozygous+ploidy.2Spar","Homozygous.2Spar","Heterozygous.2Spar",
                            "Heterozygous+aneuploidy+ploidy.3Hybrid","Heterozygous+LOH.3Hybrid",
                            "Heterozygous+ploidy.3Hybrid","Heterozygous.3Hybrid"),
                   labels=c(" 2 \n Homozygous \n mutation",
                            " 3 \n Homozygous \n mutation + \n Chromosome gain"," 2 \n Homozygous \n mutation"," 1 \n Heterozygous \n mutation",
                            " 3 \n Homozygous \n mutation + \n Chromosome gain"," 2 \n Homozygous \n mutation",
                            " 2 \n Heterozygous \n mutation + \n Chromosome gain"," 1 \n Heterozygous \n mutation"))+
  theme(legend.title = element_text(size=15),
        legend.text = element_text(size=15)) + 
  background_grid(
    major = c("xy"),
    minor = c("y"),
    size.major = 0.5,
    size.minor = 0.3,
    color.major = "grey85",
    color.minor = "grey85") + ylab("Increase in growth rate (%)") + xlab("Copies of mutated PDR1")+
  theme_bw(base_size=15) + 
  ylim(0,210)+
  theme(axis.text.x = element_text(size = 12, color="black"),
        axis.text.y = element_text(size = 12, color="black"),
        axis.title = element_text(size = 13,face="bold"))+
  theme(legend.position="none")+labs(x=my_y_title)+
  annotate("text", x = c(1,2,3,4,5,6,7,8), y=c(200,150, 149, 148,150,120,120,110), label = c("a","ab","abc","bc","abc","bc","bc","c"),size=4)+
  annotate("text",
           y = c(200),
           x = c(8),
           label = c("p < 0.05"),
           family = "", fontface = 3, size=4) 
##########

# Importing graphs to be added to the Figure:
img <-image_read_pdf("Figure3D.pdf")
gpp <- rasterGrob(img, interpolate = TRUE)
Fig3D <- plot_grid(gpp)

Figure3D_cartoon<-plot_grid(Fig3D,Figure3D,nrow=2, rel_heights = c(0.15,1))

Fig3D<-Figure3D_cartoon
#################

############Figure 3E############
fitness_PDR_events <-left_join(my_data,genomics4, by=c("Strain"="Specie",
                                                       "Replicate"="Replicate"))
scer_mut <- fitness_PDR_events %>% filter(Strain=="1Scer")
spar_mut <- fitness_PDR_events %>% filter(Strain=="2Spar")
hyb_mut <- fitness_PDR_events %>% filter(Strain=="3Hybrid")

#Check correlation graphs
all_species_correlation<- ggscatter(fitness_PDR_events, x = "Number_events", y = "percentage",
          color = "black", shape = 21, size = 3, # Points color, shape and size
          add = "reg.line",  # Add regressin line
          add.params = list(color = "blue", fill = "lightgray"), # Customize reg. line
          conf.int = TRUE, # Add confidence interval
          cor.coef = TRUE, # Add correlation coefficient. see ?stat_cor
          cor.coeff.args = list(method = "pearson", label.x =0, label.sep = "\n")
)

Hybrid_correlation<-ggscatter(hyb_mut, x = "Number_events", y = "percentage",
          color = "black", shape = 21, size = 3, # Points color, shape and size
          add = "reg.line",  # Add regressin line
          add.params = list(color = "blue", fill = "lightgray"), # Customize reg. line
          conf.int = TRUE, # Add confidence interval
          cor.coef = TRUE, # Add correlation coefficient. see ?stat_cor
          cor.coeff.args = list(method = "pearson", label.x =0, label.sep = "\n")
)

my_y_title <- expression(paste(bold("Number of "), bolditalic("PDR1"),bold("mutated copies")))

Fig3E1 <- fitness_PDR_events %>% 
  ggplot(aes(x=Number_events,y = percentage))+
  stat_smooth(method="lm", alpha=0.1)+
  annotate("text",
           y = 190,x = 1.4,
           label = c("rs = 0.55, p < 0.05"),
           family = "", fontface = 3, size=3.5) + 
  geom_point(pch=21, aes(fill=Strain), col="black", show.legend = FALSE, alpha = 0.5, size = 2)+
  ylab("Increase in growth rate (%)")+
  border()  +
  scale_fill_manual(values=c("green4", "dodgerblue1", "#FF9999"), 
                    labels = toexpr(c("S. cerevisiae", "S. paradoxus", "Hybrid")))+
  stat_smooth(method="lm", alpha=0.1)+
  theme_prism()+
  theme_bw(base_size=24) +
  ylim(0,200)+
  theme(strip.text = element_text(face = "bold", size = 9),
    strip.background = element_blank(),
    panel.background = element_blank()) +theme(strip.text.x = element_blank())+
  theme(axis.text.x = element_text(size = 12, color="black"),
        axis.text.y = element_text(size = 12, color="black"),
        axis.title = element_text(size = 13,face="bold"))+
  labs(x=my_y_title)+
  scale_x_continuous(breaks = c(1, 2, 3))

Fig3E2 <- fitness_PDR_events %>% filter(Strain=="3Hybrid")%>%
  ggplot(aes(x=Number_events,y = percentage))+
  stat_smooth(method="lm", alpha=0.1)+
  annotate("text",
           y = 190,x = 1.4,
           label = c("rs = 0.79, p < 0.05"),
           family = "", fontface = 3, size=3.5) + 
  geom_point(pch=21, aes(fill=Strain), col="black", show.legend = FALSE, alpha = 0.5, size = 2)+
  ylab("Increase in growth rate (%)")+
  border()  +
  scale_fill_manual(values=c("#FF9999"), 
                    labels = toexpr(c("Hybrid")))+
  stat_smooth(method="lm", alpha=0.1)+
  theme_prism()+
  theme_bw(base_size=24) +
  ylim(0,200)+
  theme(strip.text = element_text(face = "bold", size = 9),
        strip.background = element_blank(),
        panel.background = element_blank()) +theme(strip.text.x = element_blank())+
  theme(axis.text.x = element_text(size = 12, color="black"),
        axis.text.y = element_text(size = 12, color="black"),
        axis.title = element_text(size = 13,face="bold"))+
  labs(x=my_y_title)+
  scale_x_continuous(breaks = c(1, 2, 3))


Fig3E<-plot_grid(Fig3E1,Fig3E2,nrow=2)
#################

########Create legend Figure 3B#####
#Disclaimer data and graph are invented to get legend purposes
#Get a plot with only 2 random categories 
n13a<-fitness_PDR_events %>% filter(Strain!="3Hybrid")

n14 <- n13a %>% 
  mutate(Mutation = ifelse(Old_allele == "A", 
                           "Amino acid changes\nfound in this study",
                           ifelse(Old_allele == "C",
                                  "Amino acid changes\nfound in other studies",
                                  "Amino acid changes found in\nboth this study and other studies")))

Fig_leg<- n14 %>% ggplot(aes(Old_allele),  group=Old_allele) +
  xlab("GRN-B-HLog")+ylab("Cell count (density)")+
  geom_density(alpha = 0.7, aes(group=Old_allele,fill=Mutation)) +
  theme_bw() +
  theme(panel.spacing = unit(0.72, "cm"))+
  guides(fill=guide_legend(title=" "))+
  theme(legend.position="bottom")+
  scale_fill_manual(values = c("blue",
                               "green2",
                               "red"))+
  theme(axis.title = element_text(size=14, face = "bold"),
        strip.text = element_text(face = "bold", size = 9),
        strip.background = element_blank())+
  theme(legend.title = element_text(size=14,face = "italic"),
        legend.text = element_text(size=14)) 

legheatmap1 <- get_legend(Fig_leg)
#################

############Assemble and save Figure 3############
Fig3A_label<- plot_grid(Fig3A,labels="a",label_size=20)
Fig3B_label<- plot_grid(Fig3B,labels="b",label_size=20)
Fig3C_label<- plot_grid(Fig3C,labels="c",label_size=20)
Fig3D_label<- plot_grid(Fig3D,labels="d",label_size=20)
Fig3E_label<- plot_grid(Fig3E,labels="e",label_size=20)

Figure2up<-plot_grid(Fig3A_label,Fig3B_label,nrow=1,rel_widths = c(1.2,2))
Figurenew1 <- plot_grid(Figure2up,Fig3C_label,Fig3D_label,nrow=3,rel_heights = c(1,0.6,1.1))

Figure3<-plot_grid(Figurenew1, Fig3E_label,rel_widths= c(3,1))

legend_total<-plot_grid(legheatmap0,legheatmap1,nrow=1)

Fig3<-plot_grid(legend_total,Figure3,nrow=2,rel_heights = c(0.2,2.5))

#Save the image in the previously set working directory
ggsave (plot = Fig3, filename = "Bautista2024_Figure3_low_quality.jpg", units = "cm", device = "jpg",width =40, height =25, dpi = 300)
ggsave (plot = Fig3, filename = "Bautista2024_Figure3.png", units = "cm", device = "png",width =40, height =25, dpi = 1000,bg = "white")
ggsave (plot = Fig3, filename = "Bautista2024_Figure3.jpg", units = "cm", device = "jpg",width =40, height =25, dpi = 1000,bg = "white")
ggsave (plot = Fig3, filename = "Bautista2024_Figure3.svg", units = "cm", device = "svg",width =40, height =25, dpi = 1000,bg = "white")
ggsave (plot = Fig3, filename = "Bautista2024_Figure3.pdf", units = "cm", device = "pdf",width =40, height =25, dpi = 1000,bg = "white")
#################

