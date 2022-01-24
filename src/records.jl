using DataFrames
using CSV

include("definitions.jl")

#= GLOBAL VARIABLES =#
CURRENT_RECORDS = Ref{Records}()

#= RECORD =#
function record!(run::Run; records = CURRENT_RECORDS)
    @assert (run.name != "") "Not a valid name"
    records.size += 1
    push!(records.head.children, run)
    run.parent = records.head
    records.head = run
end

#= GET =#
function get(run::Run, name::AbstractString)
    @assert (name != "") "Not a valid name"
    nodes = [run]
    while !isempty(nodes)
        item = popfirst!(nodes)
        if item.name == name
            return item
        else
            nodes = vcat(nodes, item.children)
            println(nodes)
        end
    end
    return missing
end

function get(name::AbstractString; records = CURRENT_RECORDS)
    return get(records.sentinel, name)
end

#= CHECKOUT =#
function checkout!(name::AbstractString; records = CURRENT_RECORDS)
    records.head = get(records, name)
    return nothing
end

function checkout!(run::Run; records = CURRENT_RECORDS)
    records.head = run
    return nothing
end

#= Population =#
function population(run::Run; index = 1)
    @assert index <= length(run.population) "Index is larger than population array size"
    return run.population[index]
end

#= INIT =#
function init(;dir::AbstractString = pwd(), runs = "runs/", models = "models/")
    # if !isdir(dir)
    #     dir = joinpath(pwd(), dir)
    # end
    # @assert isdir(dir) "Directory creation failure"
    # @assert !isdir(joinpath(dir, runs)) "Records already exist"
    # @assert !isdir(joinpath(dir, models)) "Models already exist"
    # try 
    #     mkdir(joinpath(dir, runs))
    #     mkdir(joinpath(dir, models))
    # catch
    #     "Failure creating directory"
    # end
    records = Records(dir, runs, models)
    records!(records)
    return records
end

function current()
    return CURRENT_RECORDS
end

function records!(records::Records)
    global CURRENT_RECORDS = records
    return nothing
end

#= REINIT =#
function reinit!(;dir = wd)
    records = deserialize(dir)
    global CURRENT_RECORDS = records
    return records
end
