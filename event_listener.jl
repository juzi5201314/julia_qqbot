module event_listener

using WebSockets
using JSON2

export listen_to

function listen_to(;url::String="ws://127.0.0.0:6700", token::String="")
    WebSockets.open(string(url, "/event", "?access_token=", token)) do ws
        println("event listener connect to ", url)
        while true
            message, stillopen = readguarded(ws)
            #在idea中文必须encode为gb18030，不然乱码
            #String(encode(message, "gb18030"))
            data = JSON2.read(String(message), Dict{String, Any})
            if data["post_type"] == "message"
                onMessage(data)
            elseif data["post_type"] == "notice"

            elseif data["post_type"] == "request"

            end
        end
    end
end

function onMessage(data::Dict{String, Any})

end

end  # event_listener
