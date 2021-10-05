package;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxG;
import openfl.Lib;

class BullshitUtil
{
    public static function shakeScreen(rate:Float, limit:Int, times:Int)
    {
        new FlxTimer().start(rate, function(tmr:FlxTimer)
		{
			Lib.application.window.move(Lib.application.window.x + FlxG.random.int(-limit, limit), Lib.application.window.y + FlxG.random.int(-limit, limit));
		}, times);
    }

    public static function drainHealth(rate:Float, drainTimes:Int)
    {   
        new FlxTimer().start(0.01, function(tmr:FlxTimer)
        {
            PlayState.health -= 0.005;
        }, drainTimes);
    }

    var jesusScare:FlxSprite;

    public function intiateJumpscare()
    {
        jesusScare = new FlxSprite(0, 0);
        jesusScare.frames = Paths.getSparrowAtlas('lol/HOLOFUNK JUMPSCARE', 'shared');
        jesusScare.antialiasing = false;
        jesusScare.animation.addByPrefix('boo', 'lol', 24, true);
        jesusScare.animation.play('boo', true);  
    }

    public function holofunkJumpscare(lastingSeconds:Int)
    {
        PlayState.add(jesusScare);
        jesusScare.animation.play('boo', true); 
        FlxG.sound.play(Paths.sound('vineBoom', 'shared'));


    }

}