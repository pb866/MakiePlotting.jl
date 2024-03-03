## Helper functions for conversions

"""
    commasep(n)::String

Return n as string using comma instead of period.
"""
function commasep(n::T where T<:AbstractFloat)::String
  i, d = divrem(n, 1)
  i = convert(Int16, i)
  d = convert(Int16, round(1000d))
  return "$i,"*lpad(d,3,'0')
end
