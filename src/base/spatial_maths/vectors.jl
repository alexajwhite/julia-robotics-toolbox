## Spatial Maths - vectors.jl

function angdiff(val1, val2)
    # function angdiff

    d = val1 - val2
    d = mod(d+pi, 2*pi) - pi
    return d
