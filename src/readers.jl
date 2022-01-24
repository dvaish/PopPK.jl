include("records.jl")

function nonmem(model, population, fixeffs, obstimes; records = CURRENT_RECORDS, name = missing, rep = 1)
    result = []
    for _ in 1:rep
        simulated = simobs(model, population, fixeffs, obstimes = obstimes)
        push!(result, simulated)
    end
    run = Run(result; records = records, name = name)
    record!(run; records = records)
    return run
end