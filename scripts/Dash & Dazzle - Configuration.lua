-- | Dash & Dazzle - Configuration | [v1.2]

local vars = {
-- | Extras |
    DisablePause = false,

-- | StrumCamera |
    StrumCamera = 'camHUD',
    Strums = 'strumLineNotes',

-- | Icons |
    IconsScaleBeatOn = true,
    LowHealthSpin = true,
    IconWin = false,
    IconBFScale = 0.8,
    IconDadScale = 0.8,
    ScaleBeat = 0.07,

-- | HealthBar |
    LifeGain = 0.02,
    LifeDrain = 0.015,
    LifeDrainLow = 0.01,
    LifeMiss = 0.02,

-- | Simple Human Bot |
    ActivateBot = false,
    precision = 'Normal',
    customOffsetRange = {-100,80},
    missChance = 0,

-- | CamFlow |
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
        setVar(name,value)
    end
    local DashScripts = {
        'Dash & Dazzle',
        'Simple Human Bot v1.2',
        'StrumCamera',
        'DisableOptions.lua',
        'CamFlow.lua',
        'Installer.lua',
        'Events/setTrigger.lua'
    }
    for _,scriptPath in ipairs(DashScripts) do
        addLuaScript('scripts/Dash & Dazzle/'..scriptPath)
    end
end
