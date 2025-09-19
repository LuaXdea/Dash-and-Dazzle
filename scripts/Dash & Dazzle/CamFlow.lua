-- | Dash & Dazzle • CamFlow v1.6.1[Fix] [Return] |
function onUpdate()
    CamFlow = getProperty('CamFlow')
    CustomCam = getProperty('CustomCam')

    camX_opponent = getProperty('camX_opponent')
    camY_opponent = getProperty('camY_opponent')
    camX_player = getProperty('camX_player')
    camY_player = getProperty('camY_player')
    camX_gf = getProperty('camX_gf')
    camY_gf = getProperty('camY_gf')

    IndividualOffsets = getProperty('IndividualOffsets')
    GeneralOffset = getProperty('GeneralOffset')

    offset_opponent = getProperty('offset_opponent')
    offset_player = getProperty('offset_player')
    offset_gf = getProperty('offset_gf')

    directionOffsets = getProperty('directionOffsets')
end
function onUpdatePost()
    local BaseX = gfSection and camX_gf or (mustHitSection and camX_player or camX_opponent)
    local BaseY = gfSection and camY_gf or (mustHitSection and camY_player or camY_opponent)
    if CustomCam then callMethod('camFollow.setPosition',{BaseX,BaseY}) end
    local Offsets = IndividualOffsets and (gfSection and offset_gf or mustHitSection and offset_player or offset_opponent) or GeneralOffset
    local offsetX,offsetY = 0,0
    if CamFlow then
        for i = 0,7 do
            if getPropertyFromGroup('strumLineNotes',i,'animation.curAnim.name') == 'confirm' then
                offsetX = offsetX + directionOffsets[i + 1][1] * Offsets
                offsetY = offsetY + directionOffsets[i + 1][2] * Offsets
            end
        end
    end
    callMethod('camGame.targetOffset.set',{offsetX,offsetY})
end
