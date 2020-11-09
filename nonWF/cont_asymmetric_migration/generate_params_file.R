.libPaths('/workdir/mam737/Rlibs')
library(arrangements)

model <- c("auto", "X", "Y")
Ne <- c(2000) # This is the carrying capacity, number of offspring generated = generation
MC_R <- 20
mig <- seq(0.01, 0.1, length.out=6)
mig_combos <- combinations(mig,2,replace=TRUE)
MC_del <- seq(-0.1, 0.0,length.out=6)
MC_adv <- seq(1.0,1.1,length.out=6)

params.df <- data.frame(mig1=mig_combos[,1],mig2=mig_combos[,2])
#Add Model
params.df <- cbind(params.df[rep(1:nrow(params.df),each=length(model)),],model=rep(model,times=nrow(params.df)))
#Add Ne
params.df <- cbind(params.df[rep(1:nrow(params.df),each=length(Ne)),],Ne=rep(Ne,times=nrow(params.df)))
#Add MC_del
params.df <- cbind(params.df[rep(1:nrow(params.df),each=length(MC_del)),],MC_del=rep(MC_del,times=nrow(params.df)))
params.df$MC_R <- 20
params.df <- cbind(params.df[rep(1:nrow(params.df), each=length(MC_adv)), ], MC_adv=rep(MC_adv, times=nrow(params.df)))
params.df <- params.df[,c(3,4,1,2,5,7,6)]
rownames(params.df) <- NULL

write.table(params.df,file="params.txt", col.names=F, row.names=F, sep="\t", quote=F)

## Manually change 1 -> 1.0 and 0 - 0.0