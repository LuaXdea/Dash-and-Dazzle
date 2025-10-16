-- | Simple Human Bot v1.2 | by LuaXdea |
function onCreatePost()
    ActivateBot = getProperty('ActivateBot')
    precision = getProperty('precision')
    customOffsetRange = getProperty('customOffsetRange')
    missChance = getProperty('missChance')
end
function onUpdate()
    ActivateBot = getProperty('ActivateBot')
    precision = getProperty('precision')
    customOffsetRange = getProperty('customOffsetRange')
    missChance = getProperty('missChance')
end
function onUpdatePost()
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
