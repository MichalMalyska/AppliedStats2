
data {
  int<lower=1> N;
  int<lower=1> J; // Number of counties
  int<lower=1,upper=J> county[N]; // county membership
  int<lower=0,upper=1> x[N]; // floor
  real u[J]; // log uranium
  vector[N] y; // log activity
}

parameters {
  vector[J] alpha;
  real gamma0;
  real gamma1;
  real beta;
  real<lower=0> sigma;
  real<lower=0> sigma_alpha;
}

model {
  vector[N] y_hat;
  vector[J] alpha_hat;
  
  for (i in 1:N)
    y_hat[i] = alpha[county[i]] + x[i] * beta;
  
  for (j in 1:J)
    alpha_hat[j] = gamma0 + gamma1 * u[j];
    
  alpha ~ normal(alpha_hat, sigma_alpha);
  beta ~ normal(0,1);
  sigma ~ normal(0,1);
  sigma_alpha ~ normal(0,1);
  gamma0 ~ normal(0,1);
  gamma1 ~ normal(0,1);
  
  y ~ normal(y_hat, sigma);
}

generated quantities {
  vector[N] y_rep; // replications from posterior predictive dist

  for (n in 1:N) {
    real y_hat_n = alpha[county[n]] + x[n] * beta;
    y_rep[n] = normal_rng(y_hat_n, sigma);
  }
}