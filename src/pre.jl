function cohort(data, dose, time, covariates...; dose_args = covariates, id = :ID)
    population = Subject[]
    for row in eachrow(data)
        values = map(covariate -> row[covariate], covariates)
        subject = Subject(;
            id = row[id],
            events = dose(map(covariate -> row[covariate], dose_args)...),
            time = time,
            covariates = NamedTuple{covariates}(values)
        )
        push!(population, subject)
    end
    return population
end

function nonmemify(population; output = missing, missingvalue = "0")
    df = DataFrame(population)
    rename!(df, Symbol.(uppercase.(String.(names(df)))))
    df = something.(df, missing)
    if missingvalue !== missing
        df = coalesce.(df, missingvalue)
    end
    if output !== missing
        CSV.write(output, df; missingstring = missingvalue)
    end
    return df
end
