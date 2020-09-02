function r2t(R)
    #Convert SO to SE
    d = size(R)
    if (d[1] != d[2])
        error("Matrix must be square")
    end
    if (any(d[1] != [2 3]))
        error("Matrix is not a 2x2 or 3x3 rotation matrix")
    end

    n = size(R,2)
    Z = zeros(n,1)
    B = [zeros(1,n) 1]

    if count(d) == 2
        T = [R Z; B]
        return T
    else
        T = zeros(n+1, n+1,d[3])
        for i=1:d[3]
            T[:,:,i] = [R[:,:,i] Z; B]
        end
    end

    return T
end

function t2r(T, check::Bool=false)
    #Convert SE to SO
    d = size(R)
    if (d[1] != d[2])
        error("Matrix must be square")
    end

    if dim(1) == 3
        R = T[1 2; 1 2]
    elseif dim[1] == 4
        R = T[1 2 3; 1 2 3]
    else
        error("Value must be a rotation matrix")
    end

    return R

end

function tr2rt(T)
    #Convert SE(3) to SO(3)
    if (size(T,1) != size(T,2))
        error("Matrix must be square")
    end

    n = size(T,2)-1

    if size(T,3) > 1
        R = zeros(n,n,size(T,3));
        t = zeros(size(T,3), n);
        for i=1:size(T,3)
            R[1:n,1:n,i] = T[1:n,1:n,i];
            t[i,:] = T[1:n,n+1,i]';
        end
        return R,t

    else
        R = T[1:n,1:n];
        t = T[1:n,n+1];
        return R,t
    end

end

function rt2tr(R, t)
    n = size(R,2);
    B = [zeros(1,n) 1];

    if size(R,3) > 1

        T = zeros(n+1,n+1,size(R,3));
        for i=1:size(R,3)
            T[:,:,i] = [R[:,:,i] t[:,i]; B];
        end
    else
        T = [R t[:]; B];
    end
end

function skew(v)
    if isvec(v,3)
        # SO(3) case
        S = [  0   -v[3]  v[2]
              v[3]  0    -v[1]
             -v[2] v[1]   0];
    elseif isvec(v,1)
        #SO(2) case
        S = [0 -v; v 0];
    else
        error("argument must be a 1- or 3-vector");
    end
end

function skewa(s)
    s  = s(:);
    if length(s) == 3
        Omega = [skew(s[3]) s[1:2]; 0 0 0]

    elseif length(s) == 6
        Omega = [skew(s[4:6]) s[1:3]; 0 0 0 0];

    else
        error("expecting a 3- or 6-vector");
    end
end

function vex(S)
    if all(size(S) == [3 3])
        v = 0.5*[S[3,2]-S[2,3]; S[1,3]-S[3,1]; S[2,1]-S[1,2]];
    elseif all(size(S) == [2 2])
        v = 0.5*(S[2,1]-S[1,2]);
    else
        error("input must be a 2x2 or 3x3 matrix");
    end
end

function vexa(omega)
    if all(size(omega) == [4 4])
        s = [transl(omega); vex(Omega[1:3,1:3])];
    elseif all(size(omega) == [3 3])
        s = [transl2(omega); vex(Omega[1:2,1:2])];
    else
        error("argument must be a 3x3 or 4x4 matrix");
    end
end

function h2e(h)
    if isvector(h)
        h = h[:]
    end
    e = h[1:end-1,:] ./ repmat(h[end,:], numrows(h)-1, 1);
end

function e2h(e)
    h = [e; ones(1,numcols(e))];
    return h
end
