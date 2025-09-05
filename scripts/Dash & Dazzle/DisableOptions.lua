-- | Dash & Dazzle • DisableOptions |

-- | Disable settings |
local DisableDownScroll = false
-- Evita que el jugador active el DownScroll [default: false]

local DisableMiddleScroll = false
-- Evita que el jugador active el MiddleScroll [default: false]

local DisableGhostTapping = false
-- Evita que el jugador active el GhostTapping [default: false]

local DisableHideHud = false
-- Evita que el jugador active el HideHud [default: false]

local DisableScoreZoom = false
-- Evita que el jugador active el ScoreZoom [default: false]

local DisableFlashingLights = false
-- Evita que el jugador active el FlashingLights [default: false]

local DisableLowQuality = false
-- Evita que el jugador active el LowQuality [default: false]

local DisableShadersEnabled = false
-- Evita que el jugador active los shaders [default: false]

local DisablePractice = false
-- Evita que el jugador use practice [default: false]

local DisableBotPlay = false
-- Evita que el jugador use botplay [default: false]



-- Options v1.2
local defaultSettings = {}
local settings = {
    {var = downscroll,key = 'downScroll',disable = DisableDownScroll},
    {var = middlescroll,key = 'middleScroll',disable = DisableMiddleScroll},
    {var = ghostTapping,key = 'ghostTapping',disable = DisableGhostTapping},
    {var = hideHud,key = 'hideHud',disable = DisableHideHud},
    {var = scoreZoom,key = 'scoreZoom',disable = DisableScoreZoom},
    {var = flashingLights,key = 'flashing',disable = DisableFlashingLights},
    {var = lowQuality,key = 'lowQuality',disable = DisableLowQuality},
    {var = shadersEnabled,key = 'shaders',disable = DisableShadersEnabled}
}
function onCreate()
    for _,s in ipairs(settings) do
        defaultSettings[s.key] = getPropertyFromClass('backend.ClientPrefs','data.'..s.key)
        if s.var then
            setPropertyFromClass('backend.ClientPrefs','data.'..s.key,not s.disable)
        end
    end
end
function onDestroy()
    for key,value in pairs(defaultSettings) do
        setPropertyFromClass('backend.ClientPrefs','data.'..key,value)
    end
end