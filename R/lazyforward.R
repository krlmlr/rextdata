lazyforward <- function(name, env = parent.frame()) {
  se <- get(name, env)

  f_se <- formals(se)

  if (!all(c("...", ".dots") %in% names(f_se))) {
    stop("The SE version needs to have ... and .dots arguments.")
  }
  f_nse <- f_se[names(f_se) != ".dots"]

  dot_fml <- list(.dots = quote(lazyeval::lazy_dots(...)))
  forward_fml <- setdiff(names(f_nse), "...")
  forward_fml <- setNames(lapply(forward_fml, as.symbol), forward_fml)

  call_nse <- as.call(c(as.symbol(name), dot_fml, forward_fml))
  fun <- eval(bquote(function() {
    .(call_nse)
  }, as.environment(list(call_nse = call_nse))))
  formals(fun) <- f_nse
  environment(fun) <- env
  fun
}

def <- function(nse_name, se_name = paste0(nse_name, "_"), env = parent.frame())
{
  delayedAssign(nse_name, lazyforward(name = se_name, env = env), assign.env = env)
  invisible(structure(NULL, class = "lazyforward_def"))
}

test_ <- function(..., .dots, a=5, b=3, c) {
}
