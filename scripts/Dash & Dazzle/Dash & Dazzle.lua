-- | Dash & Dazzle | By LuaXdea |
local DashVersion = 'v1.0 - Beta' -- Version de Dash & Dazzle
-- [YouTube]: https://youtube.com/@lua-x-dea?si=NRm2RlRsL8BLxAl5
-- [Gamebanana]: Soon.....

-- | Psych Engine | Supported versions |
-- • 0.7.2h
-- • 0.7.3


-- | Configuración Interna |

-- | General settings |
local VersionAlert = true
--[[ Te dira avisará si la versión,
    de Psych Engine que estas usando no es compatible,
    con el Dash & Dazzle
    (0.7.2h • 0.7.3)
    [default: true]
]]


-- | UI Hits |
local ShowCombo = false -- Combo [default: false]
local ShowComboNum = true -- Combo de números [default: true]
local ShowRating = true -- Clasificaciones [default: true]


-- No tocar
local ScrollHUD = downscroll and 0 or 600
local MaxBarScale = 0.5
local OppScore = 0
local DisplayOppScore = 0
local DisplayPlayerScore = 0
local OppLife = 1
local BfLife = 1
local GameOverStart = false

local VersionCheck = version ~= '0.7.2h' and version ~= '0.7.3' -- Versiones para verificar
function onCreate()
    if VersionAlert and VersionCheck then
        makeLuaSprite('Background')
        makeGraphic('Background',screenWidth,screenHeight,'000000')
        setObjectCamera('Background','camOther')
        setProperty('Background.alpha',0.4)
        addLuaSprite('Background',true)

    local Message = 'English:\nThe Psych Engine version you are using is not compatible with "Dash & Dazzle v'..DashVersion..'"\n\nEspañol:\nLa versión de Psych Engine que estás usando no es compatible con "Dash & Dazzle v'..DashVersion..'"'
        makeLuaText('T1',Message,screenWidth,0,screenHeight / 2.5)
        setTextSize('T1',23)
        setTextColor('T1','RED')
        setTextAlignment('T1','CENTER')
        setObjectCamera('T1','camOther')
        addLuaText('T1',true)
    end
    makeLuaSprite('OpponentBar',nil,100,50 + ScrollHUD)
    makeGraphic('OpponentBar',300,15)
    setObjectCamera('OpponentBar','camHUD')
    addLuaSprite('OpponentBar',true)
    setProperty('OpponentBar.origin.x',0)
    setProperty('OpponentBar.scale.x',MaxBarScale)

    makeLuaSprite('BfBar',nil,880,50 + ScrollHUD)
    makeGraphic('BfBar',300,15)
    setObjectCamera('BfBar','camHUD')
    addLuaSprite('BfBar',true)
    setProperty('BfBar.origin.x',getProperty('BfBar.width'))
    setProperty('BfBar.scale.x',MaxBarScale)

    local NamePath = dadName
    for i = 1,4 do
        makeLuaText('T'..i,(i == 1) and NamePath or 'Player',1280,i < 3 and ((i == 1) and -450 or 455) or (i == 3) and -450 or 450,(i < 3) and 30 + ScrollHUD or 65 + ScrollHUD)
        setTextSize('T'..i,20)
        setTextBorder('T'..i,0.8,'000000')
        addLuaText('T'..i)
    end
    setProperty('showCombo',ShowCombo)
    setProperty('showComboNum',ShowComboNum)
    setProperty('showRating',ShowRating)
end
function getOptions()
    DisablePause = getProperty('DisablePause')

    IconsScaleBeatOn = getProperty('IconsScaleBeatOn')
    LowHealthSpin = getProperty('LowHealthSpin')
    IconWin = getProperty('IconWin')
    IconBFScale = getProperty('IconBFScale') or 0.8
    IconDadScale = getProperty('IconDadScale') or 0.8
    ScaleBeat = getProperty('ScaleBeat') or 0.07

    LifeGain = getProperty('LifeGain') or 0.02
    LifeDrain = getProperty('LifeDrain') or 0.015
    LifeDrainLow = getProperty('LifeDrainLow') or 0.01
    LifeMiss = getProperty('LifeMiss') or 0.02
end
function getOptionsUpdate()
    IconsScaleBeatOn = getProperty('IconsScaleBeatOn')
    LowHealthSpin = getProperty('LowHealthSpin')
    IconBFScale = getProperty('IconBFScale') or 0.8
    IconDadScale = getProperty('IconDadScale') or 0.7
    ScaleBeat = getProperty('ScaleBeat') or 0.07

    LifeGain = getProperty('LifeGain') or 0.02
    LifeDrain = getProperty('LifeDrain') or 0.015
    LifeDrainLow = getProperty('LifeDrainLow') or 0.01
    LifeMiss = getProperty('LifeMiss') or 0.02
end
function onCreatePost()
    getOptions()
    IconsWins()
    setProperty('timeBar.visible',false)
    setProperty('healthBar.visible',false)
    setProperty('scoreTxt.visible',false)
    iconBFAngleDefault = getProperty('iconBF.angle')
    iconDadAngleDefault = getProperty('iconDad.angle')
end
function onPause()
    if DisablePause then return Function_Stop; end
end

-- | Icons |
function getIconPath(char)
    local basePath = IconWin and 'icons/iconsWin/' or 'icons/'
    local name = basePath..char
    if not checkFileExists('images/'..name..'.png') then
        name = basePath..'icon-'..char
    end
    if not checkFileExists('images/'..name..'.png') then
        name = 'icons/icon-face'
    end
    return name
end
function IconsWins()
    if luaSpriteExists('iconBF') then removeLuaSprite('iconBF') end
    if luaSpriteExists('iconDad') then removeLuaSprite('iconDad') end

local pathIconBF = getIconPath(getProperty('boyfriend.healthIcon'))
    makeLuaSprite('iconBFPre',pathIconBF)
local BFframeW = getProperty('iconBFPre.width') / (IconWin and 3 or 2)
local BFframeH = getProperty('iconBFPre.height')

local pathIconDad = getIconPath(getProperty('dad.healthIcon'))
    makeLuaSprite('iconDadPre',pathIconDad)
local DadframeW = getProperty('iconDadPre.width') / (IconWin and 3 or 2)
local DadframeH = getProperty('iconDadPre.height')

    makeLuaSprite('iconBF',pathIconBF)
    loadGraphic('iconBF',pathIconBF,BFframeW,BFframeH)
    addAnimation('iconBF','idle',IconWin and {0,1,2} or {0,1},0,false)
    setProperty('iconBF.flipX',true)
    setObjectCamera('iconBF','camHUD')
    setProperty('iconBF.x',1280 - 150 * getProperty('iconBF.scale.x') - 10)
    setProperty('iconBF.y',-15 + ScrollHUD)
    setProperty('iconBF.scale.x',IconDadScale)
    setProperty('iconBF.scale.y',IconDadScale)
    playAnim('iconBF','idle',true)
    addLuaSprite('iconBF',true)

    makeLuaSprite('iconDad',pathIconDad,10,-20 + ScrollHUD)
    loadGraphic('iconDad',pathIconDad,DadframeW,DadframeH)
    addAnimation('iconDad','idle',IconWin and {0,1,2} or {0,1},0,false)
    setObjectCamera('iconDad','camHUD')
    setProperty('iconDad.scale.x',IconDadScale)
    setProperty('iconDad.scale.y',IconDadScale)
    playAnim('iconDad','idle',true)
    addLuaSprite('iconDad',true)

    removeLuaSprite('iconBFPre')
    removeLuaSprite('iconDadPre')
end
function onBeatHit()
    if IconsScaleBeatOn then
        startTween('iconBFScale','iconBF.scale',{x = IconBFScale + ScaleBeat,y = IconBFScale + ScaleBeat},0.1,{ease = 'smootherStepOut',onComplete = 'ResetScale'})
        startTween('iconDadScale','iconDad.scale',{x = IconDadScale + ScaleBeat,y = IconDadScale + ScaleBeat},0.1,{ease = 'smootherStepOut',onComplete = 'ResetScale'})
    end
end
function ResetScale()
    startTween('iconBFScale','iconBF.scale',{x = IconBFScale,y = IconBFScale},0.25,{ease = 'smootherStepOut'})
    startTween('iconDadScale','iconDad.scale',{x = IconDadScale,y = IconDadScale},0.25,{ease = 'smootherStepOut'})
end
function onEvent(n)
    if n == 'Change Character' then IconsWins() end
end

-- | Health bars |
function getEpsilon()
    local minDrain = math.min(LifeDrain or 0.01,LifeDrainLow or 0.01,LifeMiss or 0.01)
    return math.max(1e-4,minDrain * 0.5)
end
function clampLife(life)
    local eps = getEpsilon()
    if life <= eps then
        return 0
    elseif life >= 1 then
        return 1
    end
    return math.floor(life * 1000 + 0.5) / 1000
end
function opponentNoteHit(_,_,noteType)
    if noteType ~= 'No Animation' then
        OppScore = OppScore + math.random(150,350)
        if OppLife < 1 then
            OppLife = clampLife(OppLife + LifeGain)
        else
            BfLife = clampLife(BfLife - (BfLife > 0.3 and LifeDrain or LifeDrainLow))
        end
    end
end
function goodNoteHit()
    if BfLife < 1 then
        BfLife = clampLife(BfLife + LifeGain)
    else
        OppLife = clampLife(OppLife - (OppLife > 0.3 and LifeDrain or LifeDrainLow))
        OppScore = OppScore - math.random(150,450)
    end
end
function noteMiss()
    BfLife = clampLife(BfLife - LifeMiss)
end
function noteMissPress()
    BfLife = clampLife(BfLife - LifeMiss)
end

function onUpdate()
    for i = 1,2 do setProperty('iconP'..i..'.visible',false) end
    setProperty('iconBF.animation.curAnim.curFrame',(IconWin and BfLife >= 0.8 and 2 or BfLife <= 0.3 and 1) or 0)
    setProperty('iconDad.animation.curAnim.curFrame',(IconWin and OppLife >= 0.8 and 2 or OppLife <= 0.3 and 1) or 0)
    if LowHealthSpin and curStep > 0 then
        doTweenAngle('IconBFAngle','iconBF',(IconWin and BfLife >= 0.8 and iconBFAngleDefault - 360 or BfLife <= 0.3 and iconBFAngleDefault + 360) or iconBFAngleDefault,0.3)
        doTweenAngle('IconDadAngle','iconDad',(IconWin and OppLife >= 0.8 and iconDadAngleDefault - 360 or OppLife <= 0.3 and iconDadAngleDefault + 360) or iconDadAngleDefault,0.3)
    end
    getOptionsUpdate()
end
function onUpdatePost(elapsed)
    local BfColor = getProperty('boyfriend.healthColorArray')
    local DadColor = getProperty('dad.healthColorArray')

    local BfHex = rgbToHex(BfColor[1],BfColor[2],BfColor[3])
    local DadHex = rgbToHex(DadColor[1],DadColor[2],DadColor[3])

    doTweenX('BfBarTween','BfBar.scale',BfLife * MaxBarScale,0.2)
    doTweenX('OppBarTween','OpponentBar.scale',OppLife * MaxBarScale,0.2)
    setProperty('BfBar.color',getColorFromHex(BfHex))
    setProperty('OpponentBar.color',getColorFromHex(DadHex))

    local PlayerScore = getProperty('songScore')
    DisplayOppScore = lerp(DisplayOppScore,OppScore,elapsed * 10)
    DisplayPlayerScore = lerp(DisplayPlayerScore,PlayerScore,elapsed * 10)

    setTextString('T3',math.floor(DisplayOppScore))
    setTextString('T4',math.floor(DisplayPlayerScore))

    if BfLife <= 0 then
        setHealth(0)
        GameOverStart = true
    end
end

function onGameOver()
    if not GameOverStart then
        return Function_Stop;
    end
end

-- ColorHex v2 Fix
function rgbToHex(input,g,b)
    local r
    if type(input) == 'table' then
        r,g,b = input.r or input[1],input.g or input[2],input.b or input[3]
    else
        r = input
    end
    if type(r) ~= 'number' or type(g) ~= 'number' or type(b) ~= 'number' or
       r < 0 or r > 255 or g < 0 or g > 255 then
        return nil
    end
    return string.format('%02X%02X%02X',r,g,b)
end

function lerp(a,b,t)
    return a + (b - a) * math.min(1,t)
end

function Warnings(Text,Color)
    if not luaDebugMode then return end
    debugPrint(Text,Color)
end
