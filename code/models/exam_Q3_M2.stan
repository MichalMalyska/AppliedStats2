
data {
  int<lower=0> N;
  int<lower=0> P;
  vector[N] y; // Outcomes
  matrix[N,P] X;
}

parameters {
  real<lower=0> sigma;
  vector[P] beta;
}

transformed parameters {
  vector[N] mu;
  mu = X * beta;
}

model {
  sigma ~ normal(0, 1);
  beta ~ normal(0, 1);
  y ~ normal(mu, sigma);
}
