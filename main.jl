#=
main:
- Julia version: 0.0.7
- Author: soeur
- Date: 2018-09-05
=#
Config = (
    ws_url = "ws://118.25.189.162:6700",
    access_token = "xxmsb",
    api_thread_count = 2,
    api_channel_size = 60,
    listener_thread_count = 4,
    listener_channel_size = 120,
    log_level = "INFO"
)
#Config优于一切

include("logger.jl")
include("event_listener.jl")
include("api.jl")
include("command/command.jl")

function main()
    api.connect_to(url=Config.ws_url, token=Config.access_token)
    event_listener.listen_to(url=Config.ws_url, token=Config.access_token)
end

main()
