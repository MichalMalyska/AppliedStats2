data {
  int<lower=0> N;
  int<lower=0> P; // Number of slopes
  int<lower=0> C; // Number of countries
  int<lower=0> R; // Number of regions
  int<lower=1, upper=C> country[N]; // country membership
  int<lower=1, upper=R> region[C]; // region membership
  vector[N] y; // Outcomes
  matrix[N,P] X;
}

parameters {
  real<lower=0> sigma_y;
  real<lower=0> sigma_country;
  real<lower=0> sigma_region;
  vector[P] beta;
  vector[C] eta_country;
  vector[R] eta_region;
}

transformed parameters {
  vector[N] mu;
  mu = X * beta + eta_country[country] + eta_region[region[country]];
}

model {
  sigma_y ~ normal(0, 1);
  sigma_country ~ normal(0, 1);
  sigma_region ~ normal(0, 1);
  eta_country ~ normal(0, sigma_country);
  eta_region ~ normal(0, sigma_region);
  beta ~ normal(0, 1);
  y ~ normal(mu, sigma_y);
}

generated quantities {
  vector[N] log_lik;    // pointwise log-likelihood for LOO
  vector[N] y_rep; // replications from posterior predictive dist

  for (n in 1:N) {
    real post_mu = X[n] * beta + eta_country[country[n]] + eta_region[region[country[n]]];
    log_lik[n] = normal_lpdf(y[n] | post_mu, sigma_y);
    y_rep[n] = normal_rng(post_mu, sigma_y);
  }
}
