### Generate Params File

model <- c("auto", "X", "Y")
Ne <- c(2000) # This is the carrying capacity, number of offspring generated = generation
MC_R <- 20
mig <- seq(0.01, 0.1, length.out=6)
MC_del <- seq(-0.1, 0.0,length.out=6)
MC_adv <- seq(1.0,1.1,length.out=6)

params.df <- data.frame(model=rep(model, each=length(Ne)), Ne=rep(Ne, times=length(model)), stringsAsFactors=F)
params.df <- cbind(params.df[rep(1:nrow(params.df), each=length(mig)), ], mig=rep(mig, times=nrow(params.df)))
params.df <- cbind(params.df[rep(1:nrow(params.df), each=length(mig)), ], mig=rep(mig, times=nrow(params.df)))
params.df <- cbind(params.df[rep(1:nrow(params.df), each=length(MC_del)), ], MC_del=rep(MC_del, times=nrow(params.df)))
params.df <- cbind(params.df[rep(1:nrow(params.df), each=length(MC_adv)), ], MC_adv=rep(MC_adv, times=nrow(params.df)))
params.df$MC_R <- 20
rownames(params.df) <- NULL

write.table(params.df,file="params.txt", col.names=F, row.names=F, sep="\t", quote=F)

## Manually change 1 -> 1.0 and 0 - 0.0

