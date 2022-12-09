
compound.inequality <- function(lhs, rhs, comparison) {
  if (is.null(attr(lhs, 'compound-inequality-partial'))) {
    out <- rhs
    attr(out, 'compound-inequality-partial') <- do.call(comparison, list(lhs, rhs))
  } else {
    out <- do.call(comparison, list(lhs, rhs)) & attr(lhs, 'compound-inequality-partial')
  }
  
  return(out)
}

'%<<%' <- function(lhs, rhs) {
  return(compound.inequality(lhs, rhs, '<'))
}

'%<<=%' <- function(lhs, rhs) {
  return(compound.inequality(lhs, rhs, '<='))
}

'%>>%' <- function(lhs, rhs) {
  return(compound.inequality(lhs, rhs, '>'))
}

'%>>=%' <- function(lhs, rhs) {
  return(compound.inequality(lhs, rhs, '>='))
}
