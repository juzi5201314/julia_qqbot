module api

using WebSockets

include("utils.jl")

api_queue = Channel{NamedTuple}(Main.Config.api_channel_size)
echo = typemin(Int64)

function connect_to(;url::String="ws://127.0.0.0:6700", token::String="")
    @async WebSockets.open(string(url, "/api", "?access_token=", token)) do ws
        handle = function ()
            for d in api_queue
                println(writeguarded(ws, encode_json(d)))
                r, ok = readguarded(ws)
                println(String(r))
            end
        end
        println("api connect to ", url)
        for i in 1:Main.Config.api_thread_count - 1
            println("Api sub thread ", i, " start.")
            @async handle()
        end
        println("Api thread start.")
        handle()
        println("Api thread closed.")
    end
end

function push_message(action::String, data::NamedTuple)::Int64
    global echo += 1
    put!(api_queue, (
    action = action,
    params = data,
    echo = echo
    ))
    echo
end

function send_private_msg(user_id::Int64, message::String, auto_escape::Bool=false)::Int64
    push_message("send_private_msg", (user_id = user_id, message = message, auto_escape=auto_escape))
end

function send_group_msg(group_id::Int64, message::String, auto_escape::Bool=false)::Int64
    push_message("send_group_msg", (group_id = group_id, message = message, auto_escape=auto_escape))
end

function send_discuss_msg(discuss_id::Int64, message::String, auto_escape::Bool=false)::Int64
    push_message("send_discuss_msg", (discuss_id = discuss_id, message = message, auto_escape=auto_escape))
end

end  # module api
