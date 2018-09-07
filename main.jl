#=
main:
- Julia version: 0.0.7
- Author: soeur
- Date: 2018-09-05
=#
using StringEncodings

include("event_listener.jl")
include("api.jl")
include("command/command.jl")

function main()
    register_default_commands()
    api.connect_to(url=Config.url, token=Config.access_token)
    event_listener.listen_to(url=Config.url, token=Config.access_token)
end

Config = (
    url = "ws://118.25.189.162:6700",
    access_token = "xxmsb"
)

function register_default_commands()
    command.register_command("version", command.Command() do sender::command.CommandSender, data::Dict{String, Any}, args...
            println(data, args)
        end
    )
end

main()
