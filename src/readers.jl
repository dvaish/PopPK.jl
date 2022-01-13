include("records.jl")

macro nonmem(execution)
    obs = eval(execution) |> DataFrame
    return :(rename!($obs, Symbol.(uppercase.(names($obs)))))
end

function nonmem(model, population, fixeffs, obstimes; records = CURRENT_RECORDS, name = missing, rep = 1)
    result = []
    for _ in 1:rep
        simulated = simobs(model, population, fixeffs, obstimes = obstimes)
        push!(result, simulated)
    end
    run = Run(result; records = records, name = name)
    PKPD.record!(run; records = records)
    return run
end

function read(path::String)
    open(path) do file
        file_array = readlines(file)
        colnames = filter(x -> x != "", split(file_array[2], ' '))
        colnames = [Symbol(col) for col in colnames]
        data = DataFrame(fill(Float64[], length(colnames)), colnames; makeunique=true)
        for i in 3:length(file_array)
            row = file_array[i]
            if (row == file_array[1]) | (row == file_array[2])
                continue
            else
                row_vector = split(row, ' ')
                row_vector = filter(x -> x != "", row_vector)
                row_vector = map(x -> parse(Float64, x), row_vector)
                push!(data, row_vector)
            end
        end
        return data
    end
end