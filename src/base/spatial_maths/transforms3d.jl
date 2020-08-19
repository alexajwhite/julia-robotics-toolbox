CGe## Spatial Maths - transforms3d.jl
## Contains functions to create and transform 3D rotation matrices and homogenous transformation matrices.

using LinearAlgebra
using Plots
using MeshCat
using CoordinateTransformations
using Rotations
using GeometryTypes
using Colors

## HELPER FUNCTIONS

function squeeze(A::AbstractArray)
    singleton_dims = tuple((d for d in 1:ndims(A) if size(A, d) == 1)...)
    return squeeze(A, singleton_dims)
end

## MAIN FUNCTIONS

function rotx(theta, units=nothing)
    # Creates an SO3 rotation about the X-axis
    if units==nothing
        units = "rad"
    end

    if lowercase(units) != "deg" && lowercase(units) != "rad"
        error("units must be either deg or rad")
    end

    if units == "deg"
        ct = cosd(theta)
        st = sind(theta)

    else
        ct = cos(theta)
        st = sin(theta)
    end

    R = [1 0 0; 0 ct -st; 0 st ct]
    return R
end

function roty(theta, units=nothing)
    # Creates an SO3 rotation about the Y-axis
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

    R = [ct 0 st; 0 1 0; -st 0 ct]
    return R

end

function rotz(theta, units=nothing)
    # Creates S03 rotation about the Z-axis

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

    R = [ct -st 0; st ct 0; 0 0 1]
    return R

end

function trotx(theta, units=nothing)
    # Creates SE3 pure rotation about X-axis
    c = rotx(theta, units);

    T = [c [0; 0; 0]; 0 0 0 1];
    return T


end

function troty(theta, units=nothing)
    # Creates SE3 pure rotation about Y-axis
    c = roty(theta, units);

    T = [c [0; 0; 0]; 0 0 0 1];
    return T

end

function trotz(theta, units=nothing)
    # Creates SE3 pure rotation about Z-axis
    c = rotz(theta, units);

    T = [c [0; 0; 0]; 0 0 0 1];
    return T

end

function transl(x, nout=nothing, y=nothing, z=nothing)
    if y==nothing && z==nothing
        if (ishom(x))
            if (ndims(x) == 3)
                if nout==nothing || nout == 1
                    t1 = squeeze(x[1:3,4,:])'
                elseif nout == 3
                    t1 = squeeze(x[1,4,:])'
                    t2 = squeeze(x[2,4,:])'
                    t3 = squeeze(x[3,4,:])'
                else
                    error("nout", "nout must be none, 1 or 3")
                end
            else
                if nout==nothing || nout == 1
                    t1 = x[1:3,4]
                elseif nout == 3
                    t1 = x[1,4]
                    t2 = x[2,4]
                    t3 = x[3,4]
                    return [t1 t2 t3]
                else
                    error("nout", "nout must be none, 1 or 3")
                end
            end
        elseif length(x) == 3
            t = x[:]
            ident = Matrix(1.0I, 3, 3)
            t1 = [ident t; 0 0 0 1]
        else
            n = size(x,1)
            ident = Matrix(1.0I, 3, 3)
            n = [x x x]'
            t1 = [ident n; 0 0 0 1]

        end
    elseif y!=nothing && z!=nothing
        t = [x;y;z]
        ident = Matrix(1.0I, 3, 3)
        t1 = [ident t; 0 0 0 1]
    else
        error("argError", "Must input either 1 or 3 elements")
    end

    return t1



end

function ishom(T)
    d = size(T)
    if (ndims(T) >= 2)
        if (all(d[1:2] == (4,4)))
            return true
        else
            return false
        end
    else
        return false
    end
end

function isrot(R)
    d = size(R)
    if (ndims(R) >= 2)
        if ~(all(d(1:2) == [3 3]))
            return false
        else
            return true
        end
    else
        return false
    end
end

function rpy2r(roll)
    if size(roll)(1,:) == 3
        pitch = roll(:,2)
        yaw = roll(:,3)
        roll = roll(:,1)
    else
        error("size of input is incorrect")
    end
end

function trplot(T, animFromOrigin=nothing)
    ## MESHCAT Render of a transform matrix
    vis = Visualizer()
    xArrow = ArrowVisualizer(vis["coordinateFrame"]["xArrow"])
    yArrow = ArrowVisualizer(vis["coordinateFrame"]["yArrow"])
    zArrow = ArrowVisualizer(vis["coordinateFrame"]["zArrow"])

    arrowBlueMat = MeshPhongMaterial(color=RGBA(0, 0, 1, 1))
    arrowRedMat = MeshPhongMaterial(color=RGBA(1, 0, 0, 1))
    arrowGreenMat = MeshPhongMaterial(color=RGBA(0, 1, 0, 1))

    setobject!(xArrow, arrowBlueMat)
    setobject!(yArrow, arrowGreenMat)
    setobject!(zArrow, arrowRedMat)

    posX = T[1, 4]
    posY = T[2, 4]
    posZ = T[3, 4]

    o = T * [0,0,0,1]
    x = T * [1,0,0,1]
    y = T * [0,1,0,1]
    z = T * [0,0,1,1]

    settransform!(xArrow, Point(posX, posY, posZ), Vec(x[1], x[2], x[3]))
    settransform!(yArrow, Point(posX, posY, posZ), Vec(y[1], y[2], y[3]))
    settransform!(zArrow, Point(posX, posY, posZ), Vec(z[1], z[2], z[3]))

    open(vis)
end
