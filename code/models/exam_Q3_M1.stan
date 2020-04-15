
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

generated quantities {
  vector[N] log_lik;    // pointwise log-likelihood for LOO
  vector[N] y_rep; // replications from posterior predictive dist

  for (n in 1:N) {
    real post_mu = X[n] * beta;
    log_lik[n] = normal_lpdf(y[n] | post_mu, sigma);
    y_rep[n] = normal_rng(post_mu, sigma);
  }
}
