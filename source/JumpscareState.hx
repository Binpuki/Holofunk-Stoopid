package;

import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.FlxG;

class JumpscareState extends FlxState
{
    var lol:FlxSprite;

    override public function create()
    {
        super.create();

        lol = new FlxSprite(0, 0);
        lol.frames = Paths.getSparrowAtlas('lol/HOLOFUNK JUMPSCARE', 'shared');
        lol.antialiasing = false;
        lol.animation.addByPrefix('boo', 'lol', 24, true);
        FlxG.sound.playMusic(Paths.sound('vineBoom', 'shared'));
        lol.animation.play('boo', true);  
        add(lol);

        new FlxTimer().start(12, function(tmr:FlxTimer)
        {
            LoadingState.loadAndSwitchState(new MainMenuState(), true);
        });
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}