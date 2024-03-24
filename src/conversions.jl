## Helper functions for conversions

"""
    commasep(n::T where T<:AbstractFloat; digits::Int=3)::String

Return `n` as string using comma instead of period with the given number of `digits` after the comma.
"""
function commasep(n::T where T<:AbstractFloat; digits::Int=3)::String
  iszero(digits) && return "$(round(Int, n, RoundNearestTiesAway))"
  i, d = divrem(n, 1)
  i = convert(Int16, i)
  d = round(Int, 10^digits*d, RoundNearestTiesAway)
  if d == 10^digits
    i += 1
    d = 0
  end
  d = lpad(d, digits, '0')
  return "$i,$d"
end
