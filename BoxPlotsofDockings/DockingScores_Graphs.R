install.packages("tidyverse")
install.packages("ggplot2")

library(tidyverse)
library(ggplot2)

# Change the path according to your setup
Mainfolder <- "E:/FINAL_CODES/Drug Discovery/Dockings2"

setwd(Mainfolder)

# Fetch the file paths
data <- list.files(Mainfolder,recursive=T,pattern=".csv",full.names=T)
data
class(data)

# Read the data in the files
datafiles <- lapply(data,read.csv)
datafiles
class(datafiles)

# Tidyverse package will be required
df2 <- data.frame(Reduce(rbind, datafiles)) %>%
  mutate(ProteinID = str_sub(Ligand,1,5)) %>%
  mutate(ProteinID = str_to_upper(ProteinID)) %>%
  mutate(Ligand = gsub(".*_", "", Ligand))

# Words before 1st underscore 
plot <- ggplot(df2, aes(x = Ligand, y = Binding.Affinity,color=ProteinID, fill=ProteinID)) +
  geom_boxplot(outlier.colour="black", outlier.shape=8,outlier.size=2,position=position_dodge(1),color="Black")+ scale_fill_brewer(palette="Blues")+ labs(title="Binding Affinities of Compounds",x="Compounds/Drugs", y = "Binding Adffinity (kcal/mol)") +  theme_bw()+ theme(axis.text.x = element_text(angle = 45, vjust = 1,  hjust = 1))

plot

plotfacets <- plot + facet_grid(~ProteinID, scales='free') 

plotfacets

ggsave("Facets1.pdf", width = 40, height = 20, units = "cm")  


plotfacets2 <- plot + facet_grid(~Ligand, scales='free') 
plotfacets2
ggsave("Facets2.pdf", width = 40, height = 20, units = "cm") 
