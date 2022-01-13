function time(time; EVID = 0, col = :TIME)
    return (x) -> (x[col] == time) & evid(EVID)(x)
end

function evid(evid; col = :EVID)
    return (x) -> x[col] == evid
end

function id(id; col = :ID)
    return (x) -> (x[col] == id)
end

function _filter(;conditions...)
    f = (x) -> all(map((k, v) -> x[k] == v, keys(conditions), values(conditions)))
    return f
end

function ss!(data, metric::Symbol, x0::Pair, xF::Pair; col::Union{Symbol, AbstractString} = :ss)
    initial = filter(PKPD._filter(;x0), data)[metric]
    final = filter(PKPD._filter(;xF), data)[metric]

    @assert !(col in names(data)) "Column already exists"
    @assert length(initial) == length(final) "Initial and finals vectors are of different lengths"
    data[!, col] = initial - final
    return nothing
end
    