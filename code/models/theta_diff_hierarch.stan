data {
  int<lower=1> N;
  vector[N] x;
  vector[N] offset;
  int<lower=0> deaths[N];
  int<lower=0> region[N];
}
parameters {
  vector[N] alpha;
  real mu;
  real beta;
  real<lower=0> sigma_mu;
}
transformed parameters {
  vector[N] log_theta;
  log_theta = alpha + beta * x;
}
model {
  vector[N] log_lambda;
  
  log_lambda = log_theta + offset;
  
  alpha ~ normal(mu, sigma_mu);
  mu ~ normal(0,1);
  beta ~ normal(0,1);
  sigma_mu ~ normal(0,1);
  
  deaths ~ poisson_log(log_lambda);
}


