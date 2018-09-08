using JSON2

function decode_json(data, t = NamedTuple)::t
    JSON2.read(data, t)
end

function encode_json(data)::String
    JSON2.write(data)
end
