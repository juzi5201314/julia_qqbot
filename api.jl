module api

using WebSockets

export queue

include("utils.jl")

queue = Channel{String}(60)

function connect_to(;url::String="ws://127.0.0.0:6700", token::String="")
    @async WebSockets.open(string(url, "/api", "?access_token=", token)) do ws
        println("api connect to ", url)
        for d in queue
            println(writeguarded(ws, d))
            println(readguarded(ws))
        end
    end
end

function send_private_msg()
    put!(queue, encode_json(Dict{String, Any}(
    "action" => "send_private_msg",
    "params" => Dict{String, Any}(
        "user_id" => 1034236490,
        "message" => "nm"
    )
    )))
end

end  # module api
