module PopPK 

using DataFrames: index
using Base: Integer, String
using Serialization
using Random
using Pumas

include("plots.jl")
include("pre.jl")
include("post.jl")
include("readers.jl")

green = "#91BE33"
turqoise = "#18C8D0"
blue = "#178CCB"
orange = "#F48024"

end # module
