-- | Dash & Dazzle | By LuaXdea |
local DashVersion = '0.9-Test' -- Version de Dash & Dazzle
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


-- Extras
local VersionCheck = version ~= '0.7.2h' and version ~= '0.7.3' -- Versiones para verificar

function Materials()
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
end
function getOptions()
    Intro = getProperty('Intro')
    ColorBarVanilla = getProperty('ColorBarVanilla')
    HealthBarColorFix = getProperty('HealthBarColorFix')
    SmoothHealth = getProperty('SmoothHealth')
    SmoothHealthSpeed = getProperty('SmoothHealthSpeed')
    DisablePause = getProperty('DisablePause')
    DisableCameraZoom = getProperty('DisableCameraZoom')

    StrumCamera = getProperty('StrumCamera')
    Strums = getProperty('Strums')

    ScoreTxtMini = getProperty('ScoreTxtMini')
end
function getOptionsUpdate()
    BotplayTxt = getProperty('BotplayTxt')
    ForceScroll = getProperty('ForceScroll')
    ScrollX = getProperty('ScrollX')
    ScrollY = getProperty('ScrollY')
    IconScaleX = getProperty('IconScaleY')
    IconScaleY = getProperty('IconScaleY')
    IconsArrows = getProperty('IconsArrows')
    IconMove = getProperty('IconMove')
    IconsScaleBeatOn = getProperty('IconsScaleBeatOn')
    IconScaleBeatX = getProperty('IconScaleBeatX')
    IconScaleBeatY = getProperty('IconScaleBeatY')

    ActivateBot = getProperty('ActivateBot')
    precision = getProperty('precision')
    customOffsetRange = getProperty('customOffsetRange')
    missChance = getProperty('missChance')

    HealthDrainOp = getProperty('HealthDrainOp')
    Drain = getProperty('Drain')
    MinHealth = getProperty('MinHealth')
    LowHealthSpin = getProperty('LowHealthSpin')
    HealthBarLow = getProperty('HealthBarLow')
end
function UIsetting()
    local ScrollY = not ForceScroll and (downscroll and 0 or 575) or ScrollY
    setProperty('healthBar.bg.visible',false)
    callMethod('healthBar.setPosition',{-150 + ScrollX,15 + ScrollY})
    callMethod('healthBar.scale.set',{Intro and 0.01 or 0.4,Intro and 0.01 or 1})
    setProperty('healthBar.alpha',Intro and 0 or 1)

    callMethod('iconBF.setPosition',{ScrollX + (Intro and 105 or 145),30 + ScrollY})
    callMethod('iconBF.scale.set',{Intro and 0.01 or IconScaleX,Intro and 0.01 or IconScaleY})
    setProperty('iconBF.alpha',Intro and 0 or 1)

    callMethod('iconDad.setPosition',{ScrollX + (Intro and 50 or 20),30 + ScrollY})
    callMethod('iconDad.scale.set',{Intro and 0.01 or IconScaleX,Intro and 0.01 or IconScaleY})
    setProperty('iconDad.alpha',Intro and 0 or 1)

    callMethod('scoreTxt.setPosition',{-489 + ScrollX,35 + ScrollY})
    setProperty('scoreTxt.visible',ScoreTxtMini)
    setProperty('scoreTxt.alpha',Intro and 0 or 1)

    callMethod('timeBar.setPosition',{-50 + ScrollX,5 + ScrollY})
    callMethod('timeBar.scale.set',{Intro and 0.01 or 0.4,Intro and 0.01 or 1})
    setProperty('timeBar.bg.visible',false)
    setProperty('timeBar.alpha',Intro and 0 or 1)

    setProperty('timeTxt.visible',false)
    setTextString('botplayTxt',BotplayTxt)
end
function onCountdownTick(counter)
    if Intro then
        for _,i in pairs({'iconBF','iconDad'}) do
            if counter == 0 then
                startTween('healthBarScaleSet','healthBar.scale',{x = 0.05,y = 1},0.5,{ease = 'backInOut'})
                doTweenAlpha('healthBarAlpha','healthBar',1,0.5,'backInOut')
                startTween('timeBarScaleSet','timeBar.scale',{x = 0.05,y = 1},0.5,{ease = 'backInOut'})
                doTweenAlpha('timeBarAlpha','timeBar',1,0.5,'backInOut')
            elseif counter == 1 then
                doTweenX('healthBarScaleX','healthBar.scale',0.4,(bpm >= 180) and 1.5 or 2,'backInOut')
                doTweenX('timeBarScaleX','timeBar.scale',0.4,(bpm >= 180) and 1.5 or 2,'backInOut')
                doTweenAlpha(i..'Alpha',i,1,0.3,'backInOut')
                startTween(i..'Scale',i..'.scale',{x = IconScaleX,y = IconScaleY},(bpm >= 180) and 0.3 or 0.5,{ease = 'backInOut'})
            elseif counter == 2 then
                iconBFXDefault = getProperty('iconBF.x') + 30
                iconBFYDefault = getProperty('iconBF.y')
                iconDadXDefault = getProperty('iconDad.x') - 30
                iconDadYDefault = getProperty('iconDad.y')
                doTweenX(i..'X',i,(i == 'iconDad') and getProperty('iconDad.x') - 30 or getProperty('iconBF.x') + 30,(bpm >= 180) and 1 or 1.5,'backInOut')
                doTweenX(i..'ScaleX',i..'.scale',0.9,1)
            elseif counter == 3 then
                doTweenX(i..'ScaleX',i..'.scale',IconScaleX,0.5,'bounceOut')
            elseif counter == 4 then
                if ScoreTxtMini and not getProperty('cpuControlled') then
                    doTweenAlpha('ScoreMiniAlpha','scoreTxt',1,0.5)
                else
                    setProperty('.visible',false)
                end
            end
        end
    end
end
-- | Function list |
function onBeatHit()
    IconsScaleBeat() -- IconsScaleBeat
end
function onPause()
    if DisablePause then return Function_Stop; end
end
function onCreate()
    Materials() -- Materials
    ExtrasCreate() -- ExtrasCreate
end
function onCreatePost()
    getOptions() -- getOptions
    UIMaker() -- UIMaker
    UIsetting() -- UIsetting
    ExtrasCreatePost() -- ExtrasCreatePost (onCreatePost)
end
function onUpdate(elapsed)
    getOptionsUpdate() -- getOptionsUpdate
    IconsAnimations() -- IconsAnimations
    SimpleHumanBot() -- Simple Human Bot
    ExtrasUpdate() -- ExtrasUpdate (onUpdate)
end
function onUpdatePost(elapsed)
    healthBarFix() -- healthBarFix
    ExtrasUpdatePost(elapsed) -- ExtrasUpdatePost (onUpdatePost) [elapsed]
end
function goodNoteHit(membersIndex,noteData,noteType,isSustainNote)
    IconBFArrows(noteData) -- IconsArrows [noteData]
end
function opponentNoteHit(membersIndex,noteData,noteType,isSustainNote)
    IconDadArrows(noteData) -- IconsArrows [noteData]
    HealthDrain() -- HealthDrain
end
function onTimerCompleted(tag,loops,loopsLeft)
    IconsReturn(tag) -- IconsReturn [tag]
end
function onEvent(eventName,value1,value2,strumTime)
    IconMakerRefresh(eventName,value1) -- IconMakerRefresh [eventName,value1]
    EventFlow(eventName,value1,value2) -- EventFlow [eventName,value1,value2]
end


-- UIMaker
function UIMaker()
    runHaxeCode([[
import objects.HealthIcon;

    var iconBF = new HealthIcon(boyfriend.healthIcon,true);
        game.variables.set('iconBF',iconBF);
        game.add(iconBF);
        game.uiGroup.add(iconBF);

    var iconDad = new HealthIcon(dad.healthIcon,false);
        game.variables.set('iconDad',iconDad);
        game.add(iconDad);
        game.uiGroup.add(iconDad);
    ]])
end


-- IconsAnimations
function IconsAnimations()
    for i = 1,2 do setProperty('iconP'..i..'.visible',false) end
    setProperty('iconBF.animation.curAnim.curFrame',getProperty('healthBar.percent') < 20 and 1 or 0)
    setProperty('iconDad.animation.curAnim.curFrame',getProperty('healthBar.percent') > 80 and 1 or 0)
    if LowHealthSpin and curStep > 0 then
        doTweenAngle('IconBFAngle','iconBF',getProperty('healthBar.percent') < 20 and iconBFAngleDefault + 360 or iconBFAngleDefault,0.3)
        doTweenAngle('IconDadAngle','iconDad',getProperty('healthBar.percent') > 80 and iconDadAngleDefault + 360 or iconDadAngleDefault,0.3)
    end
end


-- IconMakerRefresh [eventName,value1]
function IconMakerRefresh(n,v1)
    if n == 'Change Character' then
        local iconVar = (string.lower(v1) == 'dad' or string.lower(v1) == 'opponent') and 'iconDad' or not (string.lower(v1) == 'gf' or string.lower(v1) == 'girlfriend') and 'iconBF'
        local charIcon = (iconVar == 'iconDad') and 'dad.healthIcon' or 'boyfriend.healthIcon'
        runHaxeCode(('game.variables.get("%s").changeIcon(%s)'):format(iconVar,charIcon))
    end
end


-- IconsScaleBeat v1.1
function IconsScaleBeat()
    if IconsScaleBeatOn then
        startTween('iconBFScale','iconBF.scale',{x = IconScaleBeatX,y = IconScaleBeatY},0.1,{ease = 'smootherStepOut',onComplete = 'ResetScale'})
        startTween('iconDadScale','iconDad.scale',{x = IconScaleBeatX,y = IconScaleBeatY},0.1,{ease = 'smootherStepOut',onComplete = 'ResetScale'})
    end
end
function ResetScale()
    startTween('iconBFScale','iconBF.scale',{x = IconScaleX,y = IconScaleY},0.25,{ease = 'smootherStepOut'})
    startTween('iconDadScale','iconDad.scale',{x = IconScaleX,y = IconScaleY},0.25,{ease = 'smootherStepOut'})
end


-- IconsArrows [noteData]
function IconBFArrows(noteData)
    if IconsArrows then
        local x,y = iconBFXDefault,iconBFYDefault
        if noteData == 0 then x = x - IconMove
        elseif noteData == 1 then y = y + IconMove
        elseif noteData == 2 then y = y - IconMove
        elseif noteData == 3 then x = x + IconMove end
        doTweenX('iconBFX','iconBF',x,0.15)
        doTweenY('iconBFY','iconBF',y,0.15)
        runTimer('iconBFReturn',0.15)
    end
end
function IconDadArrows(noteData)
    if IconsArrows then
        local x,y = iconDadXDefault,iconDadYDefault
        if noteData == 0 then x = x - IconMove
        elseif noteData == 1 then y = y + IconMove
        elseif noteData == 2 then y = y - IconMove
        elseif noteData == 3 then x = x + IconMove end
        doTweenX('iconDadX','iconDad',x,0.15)
        doTweenY('iconDadY','iconDad',y,0.15)
        runTimer('iconDadReturn',0.15)
    end
end


-- IconsReturn [tag]
function IconsReturn(t)
    if t == 'iconBFReturn' or t == 'iconDadReturn' then
        local char = t == 'iconBFReturn' and 'iconBF' or 'iconDad'
        doTweenX(char..'XReturn',char,_G[char..'XDefault'],0.15)
        doTweenY(char..'YReturn',char,_G[char..'YDefault'],0.15)
    end
end


-- saveFileLua [filePath,content,absolute]
function saveFileLua(filePath,content,absolute)
    local absolute = absolute or false
    runHaxeCode([[
        var path = "]]..filePath..[[";
        if (!]]..tostring(absolute)..[[) path = Paths.mods(path);
        if (!FileSystem.exists(path)) {
            var dir = path.substr(0,path.lastIndexOf("/"));
            if (!FileSystem.exists(dir)) FileSystem.createDirectory(dir);
            File.saveContent(path,"]]..content..[[");
        }
    ]])
end


-- HealthDrain
function HealthDrain()
    if HealthDrainOp and getHealth() >= MinHealth then
        addHealth(-math.abs(Drain))
    end
end


-- Simple Human Bot v1.2
function SimpleHumanBot()
    runHaxeCode([[
    var ActivateBot = ]]..tostring(ActivateBot)..[[;
    var precision = "]]..precision..[[";
    var customOffsetRange = []]..customOffsetRange[1]..[[,]]..customOffsetRange[2]..[[];
    var missChance = ]]..missChance..[[;

   if (!ActivateBot) return;
        var songPos = Conductor.songPosition;
        var randomOffset:Int;
        for (note in game.notes) {
            switch(precision) {
                case 'Normal':
                    randomOffset = FlxG.random.int(-100,100);
                case 'Expert':
                    randomOffset = FlxG.random.int(-50,50);
                case 'Custom':
                    randomOffset = FlxG.random.int(customOffsetRange[0],customOffsetRange[1]);
                default:
                    randomOffset = FlxG.random.int(-100,100);
            }
            if (note.canBeHit && note.strumTime <= songPos - randomOffset && !note.ignoreNote && FlxG.random.float(0,1) > missChance) {
                game.goodNoteHit(note);
            }
        }
        for (strum in game.playerStrums) {
            if (strum.animation.curAnim.finished && strum.animation.curAnim.name != 'static') {
                strum.playAnim('static');
            }
        }
    ]])
end


-- ExtrasCreate (onCreate)
function ExtrasCreate()
    -- setProperty('guitarHeroSustains',not HealthDrainOp)
    if getProperty('practiceMode') then
        setProperty('practiceMode',not DisablePractice)
    end
    if getProperty('cpuControlled') then
        setProperty('cpuControlled',not DisableBotPlay)
    end
    setProperty('showCombo',ShowCombo)
    setProperty('showComboNum',ShowComboNum)
    setProperty('showRating',ShowRating)
end

-- ExtrasCreatePost (onCreatePost)
function ExtrasCreatePost()
    -- [Defaults]
    iconBFXDefault = getProperty('iconBF.x')
    iconBFYDefault = getProperty('iconBF.y')
    iconDadXDefault = getProperty('iconDad.x')
    iconDadYDefault = getProperty('iconDad.y')
    iconBFAngleDefault = getProperty('iconBF.angle')
    iconDadAngleDefault = getProperty('iconDad.angle')
    runHaxeCode([[
    var Camera = game.]]..StrumCamera..[[;
    var strumGroup = game.]]..(Strums == nil and 'strumLineNotes' or Strums)..[[;

        for (strum in strumGroup) { 
            if (Camera == game.camGame) strum.scrollFactor.set(1,1);
            strum.cameras = [Camera];
        }
        for (noteSplash in game.grpNoteSplashes) {
            if (Camera == game.camGame) noteSplash.scrollFactor.set(1,1);
            noteSplash.cameras = [Camera];
        }
        for (note in game.unspawnNotes) {
            if (Camera == game.camGame) note.scrollFactor.set(1,1);
            if (strumGroup == game.opponentStrums) {
                if (!note.mustPress) note.cameras = [Camera];
            } else if (strumGroup == game.playerStrums) {
                if (note.mustPress) note.cameras = [Camera];
            } else {
                note.cameras = [Camera];
            }
        }
    // | SmoothHealth • v1.1 |
    if (]]..tostring(SmoothHealth)..[[) {
        var HealthSmooth = 1;
        healthBar.valueFunction = () -> return HealthSmooth = FlxMath.lerp(HealthSmooth,game.health,]]..(SmoothHealthSpeed or 0.5)..[[);
    }
    ]])
end

-- ExtrasUpdate (onUpdate)
function ExtrasUpdate()
    local hp,stepMod = getProperty('healthBar.percent'),curStep % 6
    local bfAlpha = hp < 20 and (stepMod == 0 and 1 or 0.1) or 1
    local dadAlpha = hp > 80 and (stepMod == 0 and 1 or 0.1) or 1
    if HealthBarLow then
        doTweenAlpha('healthBarBF','healthBar.rightBar',bfAlpha,hp < 20 and 0.15 or 0.5)
        doTweenAlpha('healthBarDad','healthBar.leftBar',dadAlpha,0.15)
    end
    if ColorBarVanilla then
        HealthBarColorFix = false
        setHealthBarColors('FF0000','00FF00')
    end
    setProperty('camZooming',not DisableCameraZoom)
end

-- ExtrasUpdatePost (onUpdatePost) [elapsed]
function ExtrasUpdatePost(elapsed)
    if VersionAlert and VersionCheck then
        setProperty('camGame.alpha',0.5)
        setProperty('camHUD.alpha',0.5)
    end
    -- Error de la 0.7.2h y 0.7.3 con el grpNoteSplashes
    for i = 0,getProperty('grpNoteSplashes.length') - 1 do
        if StrumCamera == 'camGame' and (version == '0.7.2h' or version == '0.7.3') then
            setPropertyFromGroup('grpNoteSplashes',i,'visible',false)
        end
    end
end


-- healthBarFix v1.2
function healthBarFix()
    if HealthBarColorFix then
        bfRGB,dadRGB = getProperty('boyfriend.healthColorArray'),getProperty('dad.healthColorArray')
        if areColorsSimilar(bfRGB[1],bfRGB[2],bfRGB[3],dadRGB[1],dadRGB[2],dadRGB[3]) then
            local adjustedColor = adjustColor(dadRGB[1],dadRGB[2],dadRGB[3],calculateLuminosity(dadRGB[1],dadRGB[2],dadRGB[3]))
            setHealthBarColors(rgbToHex(adjustedColor[1],adjustedColor[2],adjustedColor[3]),rgbToHex(bfRGB[1],bfRGB[2],bfRGB[3]))
        end
    end
end
function areColorsSimilar(r1,g1,b1,r2,g2,b2)
    return math.abs(r1 - r2) <= 50 and math.abs(g1 - g2) <= 50 and math.abs(b1 - b2) <= 50
end
function calculateLuminosity(r,g,b)
    return 0.299 * r + 0.587 * g + 0.114 * b
end
function adjustColor(r,g,b,lum)
    local adj = (lum > 128) and -70 or 70
    return { math.max(0,math.min(255,r + adj)),math.max(0,math.min(255,g + adj)),math.max(0,math.min(255,b + adj)) }
end


-- ColorHex v2
function rgbToHex(input,g,b)
    local r
    if type(input) == 'table' then
        r,g,b = input.r or input[1],input.g or input[2],input.b or input[3]
    else
        r = input
    end
    if type(r) ~= 'number' or type(g) ~= 'number' or type(b) ~= 'number' or
       r < 0 or r > 255 or g < 0 or g > 255 or b < 0 or b > 255 then
        return nil
    end
    return string.format('0x%02X%02X%02X',r,g,b)
end



-- Reporte cualquier error de forma detallada a LuaXdea
