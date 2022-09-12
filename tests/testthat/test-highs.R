test_that("HiGHS can solve a bin packing problem", {
    max_bins <- 5
    bin_size <- 3
    n <- 5
    weights <- rep.int(1, n)
    m <- MIPModel()
    m <- add_variable(m, y[i], i = 1:max_bins, type = "binary")
    m <- add_variable(m, x[i, j], i = 1:max_bins, j = 1:n, type = "binary")
    m <- set_objective(m, sum_expr(y[i], i = 1:max_bins), "min")
    for (i in 1:max_bins) {
        m <- add_constraint(
            m,
            sum_over(weights[j] * x[i, j], j = 1:n) <= y[i] * bin_size
        )
    }
    for (j in 1:n) {
        m <- add_constraint(m, sum_over(x[i, j], i = 1:max_bins) == 1)
    }
    result <- solve_model(m, highs_optimizer())
    expect_equal(objective_value(result), 2)
})

test_that("Obj. constant is passed to HiGHS as offset", {
    model <- MIPModel()
    model <- add_variable(model, x, lb = 0, ub = 10)
    model <- set_objective(model, x + 10, sense = "max")
    result <- solve_model(model, highs_optimizer())
    obj <- objective_value(result)
    expect_equal(obj, 20)
})
