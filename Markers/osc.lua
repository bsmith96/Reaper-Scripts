-- osc.lua

-- Utility functions to get and parse OSC message and argument from REAPER action context

local osc = {}

function osc.parse(context)
    local msg = {}

    -- Extract the message
    msg.address = context:match("^osc:/([^:[]+)")

    if msg.address == nil then
        return nil
    end
    
    -- Extract float or string value
    local value_type, value = context:match(":([fs])=([^%]]+)")
    
    if value_type == "f" then
        msg.arg = tonumber(value)
    elseif value_type == "s" then
        msg.arg = value
    end
    
    return msg
end

function osc.get()
    local is_new, name, sec, cmd, rel, res, val, ctx = reaper.get_action_context()
    if ctx == nil or ctx == '' then
        return nil
    end

    return osc.parse(ctx)
end

return osc