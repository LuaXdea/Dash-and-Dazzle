-- | CamNotes | by LuaXdea |
function onCreatePost()
    runHaxeCode([[
        var camNotes = new FlxCamera();
        camNotes.bgColor = 0x0;
        for (strum in game.strumLineNotes) strum.cameras = [camNotes];
        for (noteSplash in game.grpNoteSplashes) noteSplash.visible = false;
        for (note in game.unspawnNotes) note.cameras = [camNotes];
        camNotes.setScale(0.8,0.8);
        FlxG.cameras.remove(game.camHUD,false);
        FlxG.cameras.remove(game.camOther,false);
        FlxG.cameras.add(camNotes,false);
        FlxG.cameras.add(game.camHUD,false);
        FlxG.cameras.add(game.camOther,false);
        setVar('camNotes',camNotes);
    ]])
    for i = 0,7 do
        setPropertyFromGroup('opponentStrums',i - 4,'x',-450 - 20 + (i * 110))
        setPropertyFromGroup('playerStrums',i - 4,'x',450 - 20 + (i * 110))
        setPropertyFromGroup('strumLineNotes',i,'y',downscroll and 620 or 0)
    end
end
function onUpdatePost()
    runHaxeCode([[
    var camNotes = getVar('camNotes');
    camNotes.alpha = game.camHUD.alpha;
    camNotes.x = game.camHUD.x;
    camNotes.y = game.camHUD.y;
    camNotes.angle = game.camHUD.angle;
    ]])
end
