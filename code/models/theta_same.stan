data {
  int<lower=1> N;
  vector[N] x;
  vector[N] offset;
  int<lower=0> deaths[N];
  int<lower=0> region[N];
}
parameters {
  real alpha;
}
model {
  vector[N] log_lambda;
  for (i in 1:N) {
    log_lambda[i] = alpha + offset[i];
  }
  alpha ~ normal(0,1);
  deaths ~ poisson_log(log_lambda);
}


