## Spatial Maths - transforms2d.jl
## File contains various functions that allow the creation of translation, rotation, and homogeneous transformation matrices.

using LinearAlgebra
using Plots


## HELPER FUNCTIONS

#=
    squeeze function
    -- Removes single dimensions from the shape of the given array
=#
function squeeze(A::AbstractArray)
    singleton_dims = tuple((d for d in 1:ndims(A) if size(A, d) == 1)...)
    return squeeze(A, singleton_dims)
end


## MAIN FUNCTIONS

#=
    rot2 function
    input:
        theta - double precision value of the angle supplied
        units - a string either 'deg' (degrees) or 'rad' (radians) to
        determine the type of degree that was inputted. Defaults to 'rad'.

    -- Generates a SO2 rotation matrix
=#
function rot2(theta, units=nothing)
    # Creates an SO2 rotation

    if units==nothing
        units = "rad"
    end

    if lowercase(units) != "deg" && lowercase(units) != "rad"
        error("units must be either deg or rad")
    end

    if units === "deg"
        ct = cosd(theta)
        st = sind(theta)

    else
        ct = cos(theta)
        st = sin(theta)
    end

    R = [[ct -st]; [st ct]]

    return R
end


#=
    trot2 function
    input:
        theta - double precision value of the angle supplied
        units - a string either 'deg' (degrees) or 'rad' (radians) to
        determine the type of degree that was inputted. Defaults to 'rad'.

    -- Generates a SE2 rotation matrix
=#
function trot2(theta, unit=nothing::String)
    # Creates SE2 pure rotation

    c = rot2(theta, unit);

    T = [c [0; 0]; 0 0 1];
    return T
end


#=
    transl2 function
    input:
    x - x position of the translation
    y - y position of the translation

    -- Generates a SE2 translation matrix
=#
function transl2(x, y=nothing)
    # Creates SE2 pure translation, or translation from matrix

    if y==nothing
        d = size(x)
        if ishom2(x)
            if ndims(x) == 3
                T = squeeze(x[1:2, 3, :])'
            else
                T = x[1:2, 3]
            end
        elseif all(d[1:2] == [3 3])
            T = x[1:2,3]
        elseif length(x) == 2
            t = x[:]
            ident = Matrix(1.0I, 2, 2)
            T = [ident t; 0 0 1]
        else
            ident = Matrix(1.0I, 3, 3)
            n = size(x,1)
            T = repeat(ident, 1, 1, n)
            T[1:2,3,:] = x'
        end
    else
        t = [x; y]
        mat = Matrix(1.0I, 3, 3)
        mat[1:2, 3] = t
        return mat
    end

end

#=
    ishom2 function
    input:
        T - input matrix

    -- Tests if matrix belongs to SE2
=#
function ishom2(T)


    d = size(T)

    if ndims(T) >= 2
        if (all(d[1:2] == (3, 3)))
            return true
        else
            return false
        end

    else
        return false
    end

end


#=
    isrot2 function
    input:
        R - input matrix

    -- Test if matrix belongs to SO2
=#
function isrot2(R::Array)


    h = false
    d = size(R)

    if (ndims(R) >= 2)
        if (all!(d(1:2) == [2 2]))
            return false
        else

            for i = 1:size(R, 3)
                RR = R(:,:,i)
                e = RR' * RR - I
                if (norm(e) > 10*eps)
                    return false
                end

                e = abs(det(RR) - 1)
                if norm(e) > 10*eps
                    return false
                end
            end
        end
    end

    h = true
    return true
end

function isvec(v)
    return size(v, 2)
end

function trexp2(S, theta=nothing)
    # Exponential of the so 2 or se 2 matrix TODO write skew function in ND
    if ishom2(S) || isvec(S)
        if (ishom2(S))
            v = S[1:2, 3]
            skw = S[1:2, 1:2]
        else
            v = S[1:2]'
            skw = 1
        end
    end
end

function trprint2(T, label, fileout, format, unit)
    # Display of SO2 or SE2 matrix

end

function trplot2(T, animFromOrigin=nothing)
    # Plots a coordinate frame of the SO2 matrix
    # To animate this from origin specify animFromOrigin as true

    if size(T) == (2,2)
        T = [T [0; 0]; 0 0 1];
    end

    if animFromOrigin == nothing || animFromOrigin == false

        o = T * [0,0,1]
        x = T * [1,0,1]
        y = T * [0,1,1]

        plot([o[1],x[1]],[o[2],x[2]], xlim = (-2,2), ylim = (-2,2), arrow=true, label="X",size = (600, 600), display_type="gui", title="Axis Plot")
        plot!([o[1],y[1]],[o[2],y[2]],arrow=true, label="Y")

    elseif animFromOrigin==true
        #Runs an animation from world origin if parameter true
        wOrig = rot2(0, "deg")
        if size(wOrig) == (2,2)
            wOrig = [wOrig [0; 0]; 0 0 1];
        end
        @gif for i = 1:100

            diff = (T - wOrig)*(0.01*i)
            dAxes = wOrig + diff
            o = dAxes * [0,0, 1]
            x = dAxes * [1,0, 1] * 1
            y = dAxes * [0,1, 1] * 1

            plot([o[1],x[1]],[o[2],x[2]], xlim = (-2,2), ylim = (-2,2),arrow=true,label="X",size = (600, 600), display_type="gui", title="Axis Plot")
            plot!([o[1],y[1]],[o[2],y[2]],arrow=true, label="Y")
        end every 2
    else
        error("animFromOrigin input wrong value, must be true or false")
    end






end
