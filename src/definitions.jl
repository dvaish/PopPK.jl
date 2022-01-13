#= STRUCTS =#
abstract type AbstractRun end

mutable struct Run <: AbstractRun
    name::AbstractString
    populations::Array{Any}
    df::DataFrame
    parent::Union{Run, Nothing}
    children::Array{Run}
    function Run(populations::Array{Any}; records = CURRENT_RECORDS, name = missing) 
        # Assign name or random hash
        name = (name !== missing) ? name : randstring(5)

        # Create results table
        if length(populations) !== 0
            df = vcat([DataFrame(population) for population in populations]...)
            df.REP = repeat(1:length(populations), inner = nrow(df) ÷ length(populations)) 
        else
            df = DataFrame()
        end

        # Write CSV
        if (name !== "")
            file = joinpath(records.dir, string(name) * ".csv")
            CSV.write(file, df)
        end

        # Return Run object
        return new(
            name,
            populations,
            df,
            nothing,
            Run[]
        ) 
    end
end

Base.show(io::IO, run::Run) = begin 
    println(io, "Run: $(run.name)")
    println(io, "  parent: $(run.parent === nothing ? nothing : run.parent.name)")
    println(io, "  children: $(length(run.children))")
    println(io, "  runs: $(length(run.populations))")
end

mutable struct Records
    dir::AbstractString
    runs::AbstractString
    models::AbstractString
    
    size::Int
    sentinel::Run
    head::Run

    function Records(dir, runs, models) 
        dummy = Run([]; name = "")
        @assert !isdir(dir) "Records directory already exists"
        @assert !isdir(joinpath(dir, runs)) "Runs directory already exists"
        @assert !isdir(joinpath(dir, models)) "Models directory already exists"
        mkdir(dir)
        mkdir(joinpath(dir, runs))
        mkdir(joinpath(dir, models))
        return new(dir, runs, models, 0, dummy, dummy) 
    end
end

Base.show(io::IO, records::Records) = begin
    println(io, "Records")
    println(io, "  directory: $(records.dir)")
    print(io, "  size: $(records.size)")
end