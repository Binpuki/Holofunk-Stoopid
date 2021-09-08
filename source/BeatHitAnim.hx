package;

import flixel.FlxSprite;
import flixel.FlxG;

//For the x0o0x bg shit
class BeatHitAnim extends FlxSprite
{
    var animName:String; //The animation to play when the beat is hit

    public function new(x:Float, y:Float, ?path:Array<String> = ['stages/limonight/limoDancer', 'shared'], ?animName:String = 'danceLeft')
    {
        super(x, y);

        frames = Paths.getSparrowAtlas(path[0], path[1]); // The animation pictures
        this.animName = animName;

        playAnim(animName);
    }

    public function scaleObj(size:Float)
    {
        setGraphicSize(Std.int(width * size));
		updateHitbox();
    }

    //ahaha i didnt steal this from Character.hx at allllll ehehe
    public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
    {
        animation.play(AnimName, Force, Reversed, Frame);
    }
}