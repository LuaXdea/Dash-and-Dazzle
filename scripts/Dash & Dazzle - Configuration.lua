-- | Dash & Dazzle - Configuration | [v1.1]

local vars = {
    Intro = true,
    ColorBarVanilla = false,
    HealthBarColorFix = true,
    SmoothHealth = true,
    SmoothHealthSpeed = 0.2,
    DisablePause = false,
    DisableCameraZoom = false,

    StrumCamera = 'camHUD',
    Strums = 'strumLineNotes',
    BotplayTxt = 'BOTPLAY',
    ForceScroll = false,
    ScrollX = 0,
    ScrollY = 0,
    IconScaleX = 0.7,
    IconScaleY = 0.7,
    IconsArrows = true,
    IconMove = 7,
    IconsScaleBeatOn = true,
    IconScaleBeatX = 0.8,
    IconScaleBeatY = 0.8,

    ActivateBot = true,
    precision = 'Normal',
    customOffsetRange = {-100,80},
    missChance = 0,

    HealthDrainOp = true,
    Drain = 0.02,
    MinHealth = 0.4,
    LowHealthSpin = true,
    HealthBarLow = true,

    ScoreTxtMini = true,
    ScoreMiniTxt = nil,
    TimeScoreMini = 0.2,
    ColorScoreMini = '00FF00',

    CamFlow = true,
    CustomCam = false,

    camX_opponent = 600,
    camY_opponent = 600,
    camX_player = 700,
    camY_player = 600,
    camX_gf = 650,
    camY_gf = 450,

    IndividualOffsets = false,
    GeneralOffset = 25,

    offset_opponent = 25,
    offset_player = 25,
    offset_gf = 25,

    directionOffsets = {
        {-1,0}, -- opponent left
        {0,1},  -- opponent down
        {0,-1}, -- opponent up
        {1,0},  -- opponent right
        {-1,0}, -- player left
        {0,1},  -- player down
        {0,-1}, -- player up
        {1,0}   -- player right
    }
}
-- | No tocar nada |
function onCreate()
    for name,value in pairs(vars) do
        local haxeVal = toHaxe(value)
        runHaxeCode("game.variables.set('"..name.."',"..haxeVal..");")
    end
    local DashScripts = {
        'Dash & Dazzle.lua',
        'DisableOptions.lua',
        'ScoreMini.lua',
        'CamFlow.lua',
        'Events/setTrigger.lua'
    }
    for _,scriptPath in ipairs(DashScripts) do
        addLuaScript('scripts/Dash & Dazzle/'..scriptPath)
    end
end
function toHaxe(val)
    local t = type(val)
    if t == 'string' then
        return '"'..esc(val)..'"'
    elseif t == 'number' or t == 'boolean' then
        return tostring(val)
    elseif t == 'table' then
        local isArray,max = true,0
        for k,_ in pairs(val) do
            if type(k) ~= 'number' then
                isArray = false
            else
                if k > max then max = k end
            end
        end
        local parts = {}
        if isArray then
            for i = 1,max do
                table.insert(parts,toHaxe(val[i]))
            end
            return '['..table.concat(parts,',')..']'
        else
            for k,v in pairs(val) do
                if type(k) == 'string' then
                    table.insert(parts,k..': '..toHaxe(v))
                end
            end
            return '{'..table.concat(parts,',')..'}'
        end
    else
        return 'null'
    end
end
-- Web: Lua
function esc(s)
    local result = {}
    for i = 1,#s do
        local c = s:sub(i,i)
        local byte = string.byte(c)
        if c == "\\" then
            table.insert(result,"\\\\")
        elseif c == '"' then
            table.insert(result,'\\"')
        elseif c == "\n" then
            table.insert(result,"\\n")
        elseif c == "\r" then
            table.insert(result,"\\r")
        elseif c == "\t" then
            table.insert(result,"\\t")
        elseif c == "\b" then
            table.insert(result,"\\b")
        elseif c == "\f" then
            table.insert(result,"\\f")
        elseif byte < 32 or byte > 126 then
            table.insert(result,string.format("\\u%04x", byte))
        else
            table.insert(result,c)
        end
    end
    return table.concat(result)
end
