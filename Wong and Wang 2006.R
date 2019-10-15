# Replication of the decision making model in Wong and XJ Wang 2006
# Author: Li, Amazing Ang @ 2019.10.15
# Github: https://github.com/AmazingAng/Decision-Making-Network
#set.seed(0)
dt = 1 # ms simulation step

## Number of Neurons
N_tot = 2 # total number

## Connection Matrix
con_ff <- cbind(c(5.2e-4, 0), c(0, 5.2e-4)) # feedforward weight: input to E
con_rec <- cbind(c(0.26, -0.1), 
                 c(-0.1, 0.26)) # Recurrent connection 

par(mfrow = c(5,1), mar = c(4,4,3,2))
## Params
# State parameter 
gamma_ = 0.641 # controls the rate of saturation of S
# Synaptic parameter
tau_NMDA = 100 # ms NMDA time constant
tau_AMPA = 2 # ms AMPA time constant
# F-I curve parameter
a_ = 270
b_ = 108+0.001 # avoiding zero denominator
c_ = 0.154

## Input
sim_time = 3000 # ms: 3 seconds in total
t_tot = 3000/dt # steps
# Background input
bg_input = c(0.28,0.28) # back ground tonic input
# Background noise: Ornstein–Uhlenbeck process
sigma_noise = 0.02 # nA
ornstein_uhlenbeck <- function(T,tau,sigma=0.009,x0 = 0){
  # generate OU process with mean 0 and sigma
  # tau: synaptic time constant, can be understand as the inverse of mean reversion speed
  yita  <- rnorm(T/dt, 0, sqrt(dt))
  n  <- T/dt
  x <- c(x0)
  for (i in 2:(n+1)) {
    x[i]  <-  x[i-1] + (-x[i-1])*dt/tau + sigma*yita[i-1]*dt/sqrt(tau)
  }
  return(x[1:n+1]);
}
bg_noise = sapply(rep(t_tot,2),ornstein_uhlenbeck, tau = tau_AMPA, sigma=sigma_noise, x0 = 0 )
# Feedforward input: 0~1s: no input. 1~2s: input. 2~3s: no input
mu0 = 30 # Hz
coherence = 0.2 # coherence level of the input
right_input = rep(0, t_tot)       # right sensory input
right_input[(1000/dt+1):(2000/dt)]= mu0*(1+coherence)
left_input = rep(0, t_tot) # left sensory input
left_input[(1000/dt+1):(2000/dt)]=  mu0*(1-coherence)
ff_input = cbind(right_input, left_input)



# F-I function
FI_curve <- function(x) (a_*x-b_)/(1-exp(-c_*(a_*x-b_)))
# # plot FI curve
# seq_FI = seq(0,1,0.01)
# plot(seq_FI, FI_curve(seq_FI), type = "l")
# x_seq = seq(0,1,0.05)

## recording variables
S = matrix(0, nrow = t_tot, ncol= N_tot) # states
fr = matrix(0, nrow = t_tot, ncol= N_tot) # firing rates
syn_record = matrix(0, nrow = t_tot, ncol= N_tot) # recurrent input
input_record = matrix(0, nrow = t_tot, ncol= N_tot) # total input

## Neural equation
for(t in 2:t_tot){
  syn = S[t-1, ] %*% t(con_rec) # calculate recurrent input
  input = ff_input[t,] %*% t(con_ff)  + syn + bg_input+ bg_noise[t,] # calculate total input
  fr[t,] = FI_curve(input) # calculate firing rate using F-I curve
  S[t,] = S[t-1,] + dt/1000/tau_NMDA * (-S[t-1,])+ dt/1000*(gamma_*(1-S[t-1,])*fr[t,])# update state
  #S[t,which(S[t,]>=1)] = 1
  S[t,which(S[t,]<=0)] = 0 # bound the state variable above 0
  
  # update recording
  input_record[t,]= input 
  syn_record[t,]= syn
}


## Plot
# plot.ts(x[800:2200,1:4])
# plot.ts(delta_x_record[800:2200,])
# plot.ts(rec_input[800:2200,])
plot.ts(1:t_tot/1000*dt-1, fr[,1], ylim=c(0, max(fr)), col = "blue", type = "l", lwd = 1.5, xlab = "time", ylab = "Firing rate")
lines(1:t_tot/1000*dt-1,fr[,2], col = "red", lwd = 1)
abline(h = 15, lty= 1)
text(-0.8,17, "threshold")
abline(v = 0, lty = 3)
abline(v = 1, lty = 3)

plot.ts(1:t_tot/1000*dt-1, S[,1], col = "blue",  type = "l", lwd = 1.5, xlab = "time", ylab = "State")
lines(1:t_tot/1000*dt-1,S[,2], col = "red", lwd = 1)
abline(v = 0, lty = 3)
abline(v = 1, lty = 3)

plot.ts(1:t_tot/1000*dt-1, input_record[,1], col = "blue",  type = "l", lwd = 1.5, xlab = "time", ylab = "Total input")
lines(1:t_tot/1000*dt-1,input_record[,2], col = "red", lwd = 1)
abline(v = 0, lty = 3)
abline(v = 1, lty = 3)

plot.ts(1:t_tot/1000*dt-1, syn_record[,1], ylim=c(0, max(syn_record)),col = "blue",  type = "l", lwd = 1.5, xlab = "time", ylab = "Recurrent input")
lines(1:t_tot/1000*dt-1,syn_record[,2], col = "red", lwd = 1)
abline(v = 0, lty = 3)
abline(v = 1, lty = 3)



plot.ts(1:t_tot/1000*dt-1, ff_input[,1], ylim=c(0, max(ff_input)),col = "blue",  type = "l", lwd = 1.5, xlab = "time", ylab = "Feedforward input")
lines(1:t_tot/1000*dt-1,ff_input[,2], col = "red", lwd = 1)
abline(v = 0, lty = 3)
abline(v = 1, lty = 3)
