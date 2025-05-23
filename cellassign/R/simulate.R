

#' Simulate from the cellassign model
#'
#' Simulate RNA-seq counts from the cell-assign model
#'
#' The number of genes, cells, and cell types is automatically
#' inferred from the dimensions of rho (gene by cell-type) and
#' s (vector of length number of cells). The specification of X
#' is optional - a column of ones will always be added as an intercept.
#'
#' @param rho A gene by cell type binary matrix relating markers to cell types
#' @param s A vector of cell-specific size factors
#' @param pi An ordinal vector relating each cell to its true marker type assignment
#' @param delta Gene by cell type matrix delta (all entries with corresponding zeros
#' in rho will be ignored)
#' @param B Granularity of spline-based fitting of dispersions
#' @param a Alpha parameters for spline inference of dispersions
#' @param b Beta parameters for spline inference of dispersions
#' @param beta A gene by covariate vector of coefficients - the first column
#' should correspond to the intercept (baseline expression) values
#' @param X A cell by covariate matrix of covariates - the intercept column will
#' always be added.
#'
#' @return An N by G matrix of simulated counts
#'
#' @importFrom stats rnbinom
#'
#' @keywords internal
simulate_cellassign <- function(rho,
                                s,
                                pi,
                                delta,
                                B = 20,
                                a,
                                beta,
                                X = NULL,
                                min_Y = 0,
                                max_Y = 1000) {

  C <- ncol(rho)
  N <- length(s)
  G <- nrow(rho)
  P <- ncol(beta)
  B <- as.integer(B)

  stopifnot(length(pi) == N)
  stopifnot(nrow(beta) == G)
  stopifnot(ncol(delta) == C)
  stopifnot(nrow(delta) == G)

  X <- initialize_X(X, N)

  basis_means <- seq(from = min_Y, to = max_Y, length.out = B)
  b_init <- 2 * (basis_means[2] - basis_means[1])^2
  b <- exp(rep(-log(b_init), B))
  LOWER_BOUND <- 1e-10

  stopifnot(ncol(X) == P)

  mean_mat <- exp(log(s) + X %*% t(beta) + t((rho * delta)[,pi]))

  mean_mat_tiled <- replicate(B, mean_mat)

  phi <- apply(a * exp(sweep((sweep(mean_mat_tiled, 3, basis_means))^2, 3, -b, '*')), c(1:2), sum) + LOWER_BOUND

  counts <- sapply(seq_len(G), function(g) {
    rnbinom(N, mu = mean_mat[,g], size = phi[g,])
  })

  counts
}
