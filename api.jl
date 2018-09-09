module api

using WebSockets

include("utils.jl")

api_queue = Channel{NamedTuple}(Main.Config.api_channel_size)
return_data = Dict{Int64, String}()
echo = typemin(Int64)

function connect_to(;url::String="ws://127.0.0.0:6700", token::String="")
    @async WebSockets.open(string(url, "/api", "?access_token=", token)) do ws
        handle = function ()
            for d in api_queue
                if !writeguarded(ws, encode_json(d))
                    Main.warn!("api: ", d, "\nfail in send")
                    continue
                end
                r, ok = readguarded(ws)
                return_data[d.echo] = String(r)
            end
        end
        Main.info!("api connect to ", url)
        for i in 1:Main.Config.api_thread_count - 1
            Main.info!("Api sub thread ", i, " start.")
            @async handle()
        end
        Main.info!("Api thread start.")
        handle()
        Main.info!("Api thread closed.")
    end
end

function has_return_data(echo_id::Int64)::Bool
    echo_id in return_data
end

function get_return_data(echo_id::Int64)::String
    return_data[echo_id]
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

function set_group_kick(group_id::Int64, user_id::Int64, reject_add_request::Bool=false)
    push_message("set_group_kick", (group_id = group_id, user_id = user_id, reject_add_request=reject_add_request))
end

function set_group_ban(group_id::Int64, user_id::Int64, duration::Int)
    push_message("set_group_ban", (group_id = group_id, user_id = user_id, duration=duration))
end

end  # module api
