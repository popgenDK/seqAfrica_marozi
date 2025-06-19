

# freq is a matrix of frequencies (M sites x P populations)
# x is the chosen populations
# block is a vector of size M that denotes the block e.g. which 5Mb block the site belong to
# N is optional and denotes the number of alleles in the outgroup

library(dplyr)
bamlist <- read.table("/maps/projects/seqafrica/people/pls394/marozi/wildlions_outgroup_map2Ptigris.bamlist",header=F)

t<-read.table(gzfile('/projects/seqafrica/people/pls394/marozi/F3-outgroup/wildlionsnoIndianwOutgroup.ibs.gz'),header=T)
# indX is the sampled base for individual number X. if -output01 1 then it is 1 for major, 0 for non major and -1 for missing 
f1<- t$ind0
f1[f1==-1] <- NA
f1 = 1-f1 # allele frequency of minor allele

freq_0 <- function(x) { 
  return(length(x[x==0])/ length(x[x != -1])) 
}

count_N <- function(x) { 
  return(length(x[x != -1])) 
}

f3= apply(t[,22:23], 1, function(x) {freq_0(x)} )
#N = apply(t[,22:23], 1, function(x) {count_N(x)} )
N=2


index <-c(2,3,4,5,6,7,10,11,12,13,14,15,16) 
#index <-c(2,3,4,5,6,7,10,11,13,14,15,16) 
results <- matrix(NA,ncol=4,nrow=length(index))
count =1 
for ( i in index ) {
  ind <- paste0('ind',i)
  print(ind)
  f2 <- t %>% select(ind)
  f2[f2==-1] <- NA
  f2 = 1-f2 # allele frequency of minor allele
  
  freq <- as.matrix(cbind(f1,f2,f3))# frequency matrix
  f<- freq
  keep1<-rowSums(is.na(f))==0
  f<-f[keep1,]
  
  #calculate numeratior  
  n<-(f[,1]-f[,3])*(f[,2]-f[,3]) - f[,3]*(1-f[,3]) / (N-1)
  
  #calculate denominator                                                                                                                                                                       
  #d<-2*f[,3]*(1-f[,3])
  d<-rep(1,length(n))
  res <- 1
  keep <- d>=0
  n<-n[keep]
  d<-d[keep]
  
  #global estimate of f3                                                                                                                                                                       
  
  est<-sum(n)/sum(d)
  res<-c(est,sum(n),sum(d),sum(keep))
  names(res)<-c("F3","diff","total","Nsites")
  
  print(res)
  cat("\n")
  
  results[count,] <- res
  count <- count + 1
}

rownames(results) <- gsub("/projects/seqafrica/people/zlc187/mapping/cats/batch_1/","",bamlist[index+1,])
colnames(results) <- c("F3","diff","total","Nsites")
write.table(results, file="/projects/seqafrica/people/pls394/marozi/F3-outgroup/summary.tsv",sep="\t",col.names = T,row.names = T,quote=FALSE)

freq <- as.matrix(cbind(f1,f2,f3))# frequency matrix
# x <- c(1,2,19) # x is the chosen populations

getF3<-function (x,freq,block,N){
  
  f <- freq  
  ## extract the freqeuncies                                                                                                                                                                   
  f<-freq[,x]
  
  # remove sites with missingness for one of the 3 populations                                                                                                                                  
  keep1<-rowSums(is.na(f))==0
  f<-f[keep1,]
  
  
  #calculate numeratior                                                                                                                                                                        
  if(!missing(N)){
    N<- N[keep1]
    n<-(f[,1]-f[,3])*(f[,2]-f[,3]) - f[,3]*(1-f[,3]) / (N-1)
  } else 
    n<-(f[,1]-f[,3])*(f[,2]-f[,3])
  }

  #calculate denominator                                                                                                                                                                       
  d<-2*f[,3]*(1-f[,3])
  
  #keep only informative sites                                                                                                                                                                 
  
  res <- 1
  keep <- d>=0
  
  n<-n[keep]
  
  d<-d[keep]
  
  #global estimate of f3                                                                                                                                                                       
  
  est<-sum(n)/sum(d)
  
  res<-c(est,sum(n),sum(d),sum(keep))
  names(res)<-c("F3","diff","total","Nsites")
  
  if(missing(block))
    
    return(res)
  
  
  ## if Z values needed the use                                                                                                                                                                
  
  nb<-ctapply(n,block[keep1][keep],sum)
  db<-ctapply(d,block[keep1][keep],sum)
  lb<-ctapply(d,block[keep1][keep],length)
  Z<-NA
  se<-NA
  estJ<-NA
  
  if(length(lb)>19){
    jackRes<-blockJackUneven(cbind(nb,db,lb))
    estJ<-jackRes[2]
    se<-sqrt(jackRes[1])
    Z<-est/se
  }
  
  res<-c(est,estJ,se,Z,sum(n),sum(d),sum(keep),length(nb))
  names(res)<-c("D","Djack","SE","Z","diff","total","Nsites","Nblocks")
  
  return(res)
}
