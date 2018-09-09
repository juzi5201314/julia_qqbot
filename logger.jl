using Memento

logger = Memento.config!("debug"; fmt="{date}[{level}]: {msg}")

function info!(args...)
    info(logger, string(args...))
end

function debug!(args...)
    debug(logger, string(args...))
end

function error!(args...)
    error(logger, string(args...))
end

function warn!(args...)
    warn(logger, string(args...))
end
function notice!(args...)
    notice(logger, string(args...))
end
