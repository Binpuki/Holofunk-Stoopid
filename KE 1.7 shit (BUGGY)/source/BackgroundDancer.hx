package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class BackgroundDancer extends FlxSprite
{
	public function new(x:Float, y:Float, ?path:String = 'stages/limonight/limoDancer', ?danceName:String = 'bg dancer sketch PINK')
	{
		super(x, y);

		frames = Paths.getSparrowAtlas(path, 'shared');
		animation.addByIndices('danceLeft', danceName, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		animation.addByIndices('danceRight', danceName, [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		animation.play('danceLeft');
		antialiasing = FlxG.save.data.antialiasing;
	}

	public var danceDir:Bool = false;

	public function dance(?frame:Int = 0):Void
	{
		danceDir = !danceDir;

		if (danceDir)
			animation.play('danceRight', true, false, frame);
		else
			animation.play('danceLeft', true, false, frame);
	}
}
