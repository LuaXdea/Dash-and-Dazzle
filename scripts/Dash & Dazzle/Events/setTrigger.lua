-- ==============================================
--  setTrigger | PE: 0.7.2h • 0.7.3 | By LuaXdea
-- ==============================================

local setTrigger_saved = {} -- Almacenamiento
local MAX_HISTORY = 10 -- Maxima cantidad de guardado
local ActiveTweens = {}

local function makeKey(obj,prop,extra)
    return extra and (obj..'.'..prop..'.'..extra) or (obj..'.'..prop)
end
local function parseValue(v)
    if not v then return nil end
    v = stringTrim(v)
    if v == 'true' then return true
    elseif v == 'false' then return false end
    return tonumber(v) or v
end
local function PushHistory(key,value)
    setTrigger_saved[key] = setTrigger_saved[key] or {}
    table.insert(setTrigger_saved[key],value)
    if #setTrigger_saved[key] > MAX_HISTORY then
        table.remove(setTrigger_saved[key],1)
    end
end
local function getPenultimate(key)
    local t = setTrigger_saved[key]
    if not t or #t == 0 then return nil end
    return (#t >= 2) and t[#t - 1] or t[#t]
end
local function ensureXY(target)
    if not target or (target.x == nil and target.y == nil) then return nil end
    target.x,target.y = target.x or target.y,target.y or target.x
    return target
end
local function resolveGetValue(obj,prop,isXY)
    local entry = getPenultimate(makeKey(obj,prop))
    if entry then
        return isXY and {x = entry.x,y = entry.y} or entry
    end
    return isXY and {x = getProperty(obj..'.'..(prop == 'setPosition' and 'x' or prop..'.x')),y = getProperty(obj..'.'..(prop == 'setPosition' and 'y' or prop..'.y'))} or getProperty(obj..'.'..prop)
end

local function setLua(obj,prop,target,axis,isSetMode)
    local key = makeKey(obj,prop,axis)
    if ActiveTweens[key] then
        cancelTween(ActiveTweens[key])
        ActiveTweens[key] = nil
    end
    if isSetMode then
        target = ensureXY(target)
        if not target then return debugPrint('[setTrigger] ERROR: Uso de set en '..prop..' requiere X e Y válidos','RED') end
        callMethod(obj..'.'..prop..'.set',{target.x,target.y})
        return
    end
    if prop == 'setPosition' then
        target = ensureXY(target)
        if not target then return debugPrint('[setTrigger] ERROR: setPosition requiere X e Y válidos para '..obj,'RED') end
        callMethod(obj..'.setPosition',{target.x,target.y})
        return
    end
    if axis then
        if target == nil then return debugPrint('[setTrigger] ERROR: Valor nulo para '..prop..'.'..axis..' en '..obj,'RED') end
        setProperty(obj..'.'..prop..'.'..axis,target)
    else
        if target == nil then return debugPrint('[setTrigger] ERROR: Valor nulo para '..prop..' en '..obj,'RED') end
        if prop == 'color' then
            setProperty(obj..'.'..prop,getColorFromHex(target))
        else
            setProperty(obj..'.'..prop,target)
        end
    end
end
local function TweenLua(obj,prop,target,axis,isSetMode,duration,ease)
    if not duration or duration <= 0 then
        return debugPrint('[setTrigger] ERROR: Duración de tween inválida para '..prop..' en '..obj,'RED')
    end
    local key = makeKey(obj,prop,axis)
    if ActiveTweens[key] then
        cancelTween(ActiveTweens[key])
        ActiveTweens[key] = nil
    end
    local tag = 'setTrigger_'..obj..'_'..prop..'_'..math.random(10000)
    ActiveTweens[key] = tag
    if isSetMode then
        target = ensureXY(target)
        if not target then return debugPrint('[setTrigger] ERROR: Tween con set en '..prop..' requiere X e Y válidos','RED') end
        startTween(tag,obj..'.'..prop,{x = target.x,y = target.y},duration,{ease = ease or 'linear'})
        return
    end
    if prop == 'setPosition' then
        target = ensureXY(target)
        if not target then return debugPrint('[setTrigger] ERROR: Tween setPosition requiere X e Y válidos en '..obj,'RED') end
        startTween(tag,obj,{x = target.x,y = target.y},duration,{ease = ease or 'linear'})
        return
    end
    if axis then
        if target == nil then return debugPrint('[setTrigger] ERROR: Tween con valor nulo para '..prop..'.'..axis..' en '..obj,'RED') end
        startTween(tag,obj..'.'..prop,{[axis] = target},duration,{ease = ease or 'linear'})
    else
        if target == nil then return debugPrint('[setTrigger] ERROR: Tween con valor nulo para '..prop..' en '..obj,'RED') end
        if prop == 'color' then
            doTweenColor(tag,obj,target,duration,ease or 'linear')
        else
            startTween(tag,obj,{[prop] = target},duration,{ease = ease or 'linear'})
        end
    end
end
-- | Evento |
function onEvent(name,v1,v2)
    if name ~= 'setTrigger' or not v1 or v1 == '' then return end
    local args = stringSplit(v1,',')
    local obj,prop = args[1],args[2]
    if not obj or not prop then return debugPrint('[setTrigger] ERROR: Faltan argumentos (objeto,propiedad)','RED') end
    local isSetMode,axis,target
    if args[3] == 'set' then
        isSetMode = true
        if args[4] and args[4]:lower() == 'get' then
            target = resolveGetValue(obj,prop,true)
        else
            local xVal = parseValue(args[4])
            if not xVal then return debugPrint('[setTrigger] ERROR: Se usó set sin valores válidos en '..prop..' de '..obj,'RED') end
            target = {x = xVal,y = parseValue(args[5]) or xVal}
        end
    elseif prop == 'setPosition' then
        if args[3] and args[3]:lower() == 'get' then
            target = resolveGetValue(obj,prop,true)
        else
            local xVal = parseValue(args[3])
            if not xVal then return debugPrint('[setTrigger] ERROR: setPosition requiere al menos un valor numérico en '..obj,'RED') end
            target = {x = xVal,y = parseValue(args[4]) or xVal}
        end
    elseif args[3] and args[3]:lower() == 'get' then
        target = resolveGetValue(obj,prop,false)
    elseif args[4] then
        axis,target = args[3],parseValue(args[4])
    else
        target = parseValue(args[3])
    end
    local key = makeKey(obj,prop,axis)
    if (isSetMode or prop == 'setPosition') and target and target.x then
        PushHistory(key,{x=target.x,y=target.y})
    elseif target ~= nil then
        PushHistory(key,target)
    end
    if type(target) == 'boolean' then
        if not (isSetMode or prop == 'setPosition') then
            setProperty(obj..'.'..prop,target)
        end
        return
    end
    if not v2 or v2 == '' then
        setLua(obj,prop,target,axis,isSetMode)
    else
        local args2 = stringSplit(v2,',')
        TweenLua(obj,prop,target,axis,isSetMode,tonumber(args2[1]) or 0,args2[2] or 'linear')
    end
end
