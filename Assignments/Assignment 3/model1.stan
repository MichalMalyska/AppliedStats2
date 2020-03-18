data {
  int<lower=0> N;
  vector[N] a; // arsenic level (mean zero)
  vector[N] d; // distance (mean zero)
  vector[N] da; // arsenic level * distance (both mean zero)
  vector[N] loga; // logarithm of arsenic level (mean zero over logs)
  vector[N] dloga; // distance (mean zero) * logarithm of arsenic level (mean zero over logs)
  int<lower=0, upper=1> y[N]; // switched vs not
}

parameters {
  real beta0;
  real beta1;
  real beta2;
  real beta3;
}

transformed parameters {
  vector[N] logit_value;
  logit_value = beta0 + beta1 * a + beta2 * d + beta3 * da;
}

model {
  y ~ bernoulli_logit(logit_value);

  beta0 ~ normal(0,1);
  beta1 ~ normal(0,1);
  beta2 ~ normal(0,1);
  beta3 ~ normal(0,1);
}

generated quantities {
  vector[N] log_lik;    // pointwise log-likelihood for LOO
  vector[N] y_rep; // replications from posterior predictive dist

  for (n in 1:N) {
    real logit_hat_n = beta0 + beta1 * a[n] + beta2 * d[n] + beta3 * da[n];
    log_lik[n] = bernoulli_logit_lpmf(y[n] | logit_hat_n);
    y_rep[n] = bernoulli_logit_rng(logit_hat_n);
  }
}
