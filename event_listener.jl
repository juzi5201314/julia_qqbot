module event_listener

using WebSockets

include("utils.jl")

function listen_to(;url::String="ws://127.0.0.0:6700", token::String="")
    WebSockets.open(string(url, "/event", "?access_token=", token)) do ws
        println("event listener connect to ", url)
        while true
            message, stillopen = readguarded(ws)
            #在idea中文必须encode为gb18030，不然乱码
            #String(encode(message, "gb18030"))
            data = decode_json(String(message))
            if data.post_type == "message"
                on_message(data)
            elseif data.post_type == "notice"

            elseif data.post_type == "request"

            end
        end
    end
end

function on_message(data::NamedTuple)
    args = split(data.message, " ")
    if Main.command.has_command(String(args[1]))
        Main.command.call_command(String(args[1]), Main.command.CommandSender(data.user_id, message -> data.message_type == "private" ? Main.api.send_private_msg(data.user_id, message) : data.message_type == "group" ? Main.api.send_group_msg(data.group_id, message) : Main.api.send_discuss_msg(data.discuss_id, message)), data, (length(args) <= 1 ? () : args[2:length(args)])...)
    end
end

end  # event_listener
