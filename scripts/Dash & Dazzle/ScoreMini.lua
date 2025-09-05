-- | Dash & Dazzle • ScoreMini |
function onCreatePost()
    ScoreTxtMini = getProperty('ScoreTxtMini')
    ScoreMiniTxt = getProperty('ScoreMiniTxt')
    TimeScoreMini = getProperty('TimeScoreMini')
    ColorScoreMini = getProperty('ColorScoreMini')
end
local ScoreActual = getProperty('songScore')
local timerUp,timerDown,incrementStageUp,incrementStageDown = 0,0,0,0
local incrementSpeed = {up = 1,down = 1}
function onUpdatePost(elapsed)
    local TargetScore = getProperty('songScore')
    timerUp = timerUp + elapsed
    timerDown = timerDown + elapsed
    if timerUp >= TimeScoreMini then
        incrementStageUp = incrementStageUp + 1
        incrementSpeed.up = 1 + (2 * incrementStageUp)
        timerUp = 0
    end
    if timerDown >= TimeScoreMini then
        incrementStageDown = incrementStageDown + 1
        incrementSpeed.down = math.min(1 + incrementStageDown, 4)
        timerDown = 0
    end
    if ScoreActual ~= TargetScore then
        local direction = (ScoreActual < TargetScore) and 'up' or 'down'
        ScoreActual = ScoreActual + ((direction == 'up') and incrementSpeed.up or -incrementSpeed.down)
        setProperty('scoreTxt.color',getColorFromHex((direction == 'up') and ColorScoreMini or 'FF0000'))
        if (direction == 'up' and ScoreActual > TargetScore) or (direction == 'down' and ScoreActual < TargetScore) then
            ScoreActual = TargetScore
        end
        if ScoreActual == TargetScore then
            doTweenColor('ScoreR','scoreTxt','FFFFFF',0.3)
            incrementSpeed.up,incrementSpeed.down = 1,1
            incrementStageUp,incrementStageDown = 0,0
        end
    end
    if ScoreTxtMini and not getProperty('cpuControlled') then
        local ScoreMiniTxt = ScoreMiniTxt == nil and '' or ScoreMiniTxt
        setTextString('scoreTxt',ScoreMiniTxt..math.floor(ScoreActual))
    end
end