#==========================================================================================+
|        MaterialPointGenerator.jl: Generate structured material particles in Julia        |
+------------------------------------------------------------------------------------------+
|  File Name  : utils.jl                                                                   |
|  Description: Some helper functions in this package                                      |
|  Programmer : Zenan Huo                                                                  |
|  Start Date : 01/01/2022                                                                 |
|  Affiliation: Risk Group, UNIL-ISTE                                                      |
|  Functions  : 01. fastvtp                                                                |
|               02. savedata                                                               |
|               03. readdata                                                               |
|               04. savexyz                                                                |
|               05. readxyz                                                                |
|               06. sortbycol                                                              |
+==========================================================================================#

export fastvtp
export savedata
export readdata
export savexy
export savexyz
export readxy
export readxyz
export sortbycol
export sortbycol!

"""
    fastvtp(coords; vtp_file="output.vtp", data::T=NamedTuple())

Description:
---
Generates a `.vtp` file by passing custom fields.
"""
function fastvtp(coords; vtp_file="output.vtp", data::T=NamedTuple()) where T <: NamedTuple
    pts_num = size(coords, 1)
    vtp_cls = [MeshCell(PolyData.Verts(), [i]) for i in 1:pts_num]
    vtk_grid(vtp_file, coords', vtp_cls, ascii=false) do vtk
        keys(data) ≠ () && for vtp_key in keys(data)
            vtk[string(vtp_key)] = getfield(data, vtp_key)
        end
    end
    return nothing
end

"""
    savedata(file_dir::String, data)

Description:
---
Save the data `data` to the file `file_dir`.
"""
function savedata(file_dir::String, data)
    open(file_dir, "w") do io
        writedlm(io, data, '\t')
    end
end

"""
    readdata(file_dir::String)

Description:
---
Read the data from `file_dir`.
"""
function readdata(file_dir::String)
    data = readdlm(file_dir, '\t')
    data = size(data, 2) == 1 ? data[:] : data
    return data
end

"""
    savexy(file_dir::P, pts::T) where {P <: String, T <: AbstractMatrix}

Description:
---
Save the 2D points `pts` to the `.xy` file (`file_dir`).
"""
function savexy(file_dir::P, pts::T) where {P <: String, T <: AbstractMatrix}
    size(pts, 2) == 2 || throw(ArgumentError("The input points should have 2 columns."))
    open(file_dir, "w") do io
        writedlm(io, pts, ' ')
    end
end

"""
    savexyz(file_dir::P, pts::T) where {P <: String, T <: AbstractMatrix}

Description:
---
Save the 3D points `pts` to the `.xyz` file (`file_dir`).
"""
function savexyz(file_dir::P, pts::T) where {P <: String, T <: AbstractMatrix}
    size(pts, 2) == 3 || throw(ArgumentError("The input points should have 3 columns."))
    open(file_dir, "w") do io
        writedlm(io, pts, ' ')
    end
end

"""
    readxy(file_dir::P) where P <: String

Description:
---
Read the 2D `.xy` file from `file_dir`.
"""
function readxy(file_dir::P) where P <: String
    xyz = readdlm(file_dir, ' ', Float64)
    size(xyz, 2) == 2 || throw(ArgumentError("The input file should have 2 columns."))
    return xyz
end

"""
    readxyz(file_dir::P) where P <: String

Description:
---
Read the 3D `.xyz` file from `file_dir`.
"""
function readxyz(file_dir::P) where P <: String
    xyz = readdlm(file_dir, ' ', Float64)
    size(xyz, 2) == 3 || throw(ArgumentError("The input file should have 3 columns."))
    return xyz
end

"""
    sortbycol(pts, col::T) where T <: Int

Description:
---
Sort the points in `pts` according to the column `col`.
"""
function sortbycol(pts, col::T) where T <: Int
    return pts[sortperm(pts[:, col]), :]
end

function sortbycol!(pts, col::T) where T <: Int
    tmp = @views pts[sortperm(pts[:, col]), :]
    pts .= tmp
end