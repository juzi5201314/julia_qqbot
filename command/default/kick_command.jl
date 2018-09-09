@register_command "kick" Command() do sender::CommandSender, data::NamedTuple, args...
    if length(args) >= 1
        Main.api.set_group_kick(data.group, args[1])
    end
    sender.reply("No user needed for kick was found.")
end
