context("Basic operations")

test_that("cellassign(...) returns a valid object", {
  library(SummarizedExperiment)
  data(example_sce)
  data(example_marker_mat)
  N <- ncol(example_sce)
  G <- nrow(example_marker_mat)
  C <- ncol(example_marker_mat)

  fit <- cellassign(example_sce[rownames(example_marker_mat),],
                    example_marker_mat,
                    s = sizeFactors(example_sce),
                    max_iter_adam = 2,
                    max_iter_em = 2)

  expect_is(fit, "cellassign")

  cell_types <- fit$cell_type

  expect_equal(length(cell_types), N)

  cell_type_names <- sort(unique(cell_types))

  expect_equal(cell_type_names, sort(colnames(example_marker_mat)))

  print(dim(fit$mle_params$gamma))

  expect_equal(C, ncol(fit$mle_params$gamma))

  expect_equal(N, nrow(fit$mle_params$gamma))

})

test_that("cellassign(...) returns a valid SingleCellExperiment", {
  library(SummarizedExperiment)
  data(example_sce)
  data(example_marker_mat)
  N <- ncol(example_sce)
  G <- nrow(example_marker_mat)
  C <- ncol(example_marker_mat)

  sce <- cellassign(example_sce[rownames(example_marker_mat),],
                    example_marker_mat,
                    s = sizeFactors(example_sce),
                    max_iter_adam = 2,
                    max_iter_em = 2,
                    return_SCE = TRUE)

  expect_is(sce, "SingleCellExperiment")

  expect_true("cellassign_celltype" %in% names(colData(sce)))
  expect_true("cellassign" %in% names(sce@metadata))

})


test_that("marker_gene_list() works as required", {

  data(example_sce)
  data(example_marker_mat)

  marker_gene_list <- list(
    Group1 = c("Gene1", "Gene3", "Gene4", "Gene5", "Gene10"),
    Group2 = c("Gene2", "Gene6", "Gene7", "Gene8", "Gene9")
  )

  mat <- marker_list_to_mat(marker_gene_list, include_other = FALSE)

  expect_equal(nrow(mat), 10)

  expect_equal(ncol(mat), 2)

  expect_equal(length(setdiff(unlist(marker_gene_list), rownames(mat))), 0)

  expect_equal(sum(mat), length(unique(unlist(marker_gene_list))))

  fit <- cellassign(example_sce[rownames(mat),],
                    marker_gene_list,
                    s = sizeFactors(example_sce),
                    max_iter_adam = 2,
                    max_iter_em = 2)

})
