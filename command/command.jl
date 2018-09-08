module command

export Command, get_commands, register_command, call_command, get_command, has_command

include("command_sender.jl")

struct Command
    exec::Function
end

commands = Dict{String, Command}()

function get_commands()::Dict{String, Command}
    commands
end


macro register_command(name::String, cmd::Expr, force::Bool = false)
    if !has_command(name) || force
        commands[name] = eval(cmd)
    end
end

function get_command(name::String)
    commands[name]
end

function has_command(name::String)::Bool
    name in keys(commands)
end

function call_command(name::String, sender::CommandSender, data::NamedTuple, args...)
    get_command(name).exec(sender, data, args...)
end

include("default/default_command.jl")

end  # modul command
