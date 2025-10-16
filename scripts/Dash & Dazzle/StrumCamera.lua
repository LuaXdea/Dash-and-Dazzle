-- | StrumCamera | by LuaXdea |
local Disable = false
function onCreatePost()
    if Disable then return end
    StrumCamera = getProperty('StrumCamera')
    Strums = getProperty('Strums')
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
    ]])
end
-- Temporal
function onUpdatePost()
    for i = 0,getProperty('grpNoteSplashes.length') - 1 do
        if StrumCamera == 'camGame' and (version == '0.7.2h' or version == '0.7.3') then
            setPropertyFromGroup('grpNoteSplashes',i,'visible',false)
        end
    end
end
