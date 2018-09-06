module api

using WebSockets
using JSON2

export queue

queue = Channel{String}(60)

function connect_to(;url::String="ws://127.0.0.0:6700", token::String="")
    WebSockets.open(string(url, "/api", "?access_token=", token)) do ws
        println("api connect to ", url)
        send_private_msg()
        send_private_msg()
        for d in queue
            println(writeguarded(ws, d))
            println(d)
            println(readguarded(ws))
        end
    end
end

function send_private_msg()
    d = JSON2.write(Dict{String, Any}(
    "action" => "send_private_msg",
    "params" => Dict{String, Any}(
        "user_id" => 1034236490,
        "message" => "nm"
    )
    ))
    put!(queue, d)
end

end  # module api
