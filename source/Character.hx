package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import CoolUtil;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var spriteIsPlayer:Bool = false; //FOR CUSTOM DEATH SHIT, ELSE IT AUTOMATICALLY SWITCHES TO BF
	public var specialStatus:String = '';

	public var customDeath:Bool = false; //For BF Characters 
	public var deathPrefix:String = ''; //In case there's a seperate path for death shit
	public var deathSuffix:String = ''; //Pathfinding for audio

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = FlxG.save.data.antialiasing;

		//Load the shit
		var charInfo:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterData/' + character));
		
		var pixelShit:Bool = false;
		var pixelSize:Int = 6;

		//Check teh shit
		for (i in 0...charInfo.length)
		{
			//split shit
			var splitShit:Array<String> = charInfo[i].split(':');

			//Check for file path
			switch(splitShit[0])
			{
				case 'file':
					frames = Paths.getSparrowAtlas('characters/' + splitShit[1]);
				case 'pixel':
				{
					if (splitShit[1] == 'true')
						pixelShit = true;

					if (splitShit[2] != null)
						pixelSize = Std.parseInt(splitShit[2]);
				}
				case 'playable':
					if (splitShit[1] == 'true')
						spriteIsPlayer = true;
				case 'special':
					specialStatus = splitShit[1];
				case 'customDeath':
					if (splitShit[1] == 'true')
						customDeath = true;
				case 'deathPrefix':
					deathPrefix = splitShit[1];
				case 'stageSuffix':
					deathSuffix = splitShit[1];

				case 'animation':
				{
					var poopoo = i + 1;
					var peepee:Array<String> = new Array<String>();
					
					for (ass in 0...charInfo.length - poopoo)
					{
						peepee[ass] = charInfo[poopoo + ass];
					}

					loadAnimations(peepee);
					break;
				}
			}
		}

		if (pixelShit) //Do pixel shit
		{
			setGraphicSize(Std.int(width * pixelSize));
			updateHitbox();

			if (spriteIsPlayer)
			{
				width -= 100;
				height -= 100;
			}

			antialiasing = false;
		}

		if (spriteIsPlayer)
			flipX = true;

		switch (specialStatus)
		{
			case 'spooky':
				playAnim('danceRight');
			case 'gf':
				playAnim('danceRight');
			case 'dead':
				playAnim('firstDeath');
			default:
				playAnim('idle');
		}

		//end of binpuki code

		dance();

		if (isPlayer && frames != null)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	function loadAnimations(animData:Array<String>)
	{
		var poop:Array<String>;

		for (i in 0...animData.length)
		{
			poop = animData[i].split(':');

			switch (poop[5])
			{
				case 'prefix':
					animation.addByPrefix(poop[0], poop[1], Std.parseInt(poop[2]), false);
					addOffset(poop[0], Std.parseInt(poop[3]), Std.parseInt(poop[4]));
				case 'indices': //IN DEEZ NUTS
				{
					var deez:Array<String> = poop[6].split(',');
					var nuts:Array<Int> = new Array<Int>();
					
					for (j in 0...deez.length)
					{
						nuts[j] = Std.parseInt(deez[j]);
					}

					animation.addByIndices(poop[0], poop[1], nuts, "", Std.parseInt(poop[2]), false);
					addOffset(poop[0], Std.parseInt(poop[3]), Std.parseInt(poop[4]));
				}
			}
		}
	}

	public function loadOffsetFile(character:String, library:String = 'shared')
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.txt('images/characters/' + character + "Offsets", library));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(forced:Bool = false, altAnim:Bool = false)
	{
		if (!debugMode)
		{
			switch (specialStatus)
			{
				case 'gf':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					if (altAnim && animation.getByName('idle-alt') != null)
						playAnim('idle-alt', forced);
					else
						playAnim('idle', forced);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{

		if (AnimName.endsWith('alt') && animation.getByName(AnimName) == null)
		{
			#if debug
			FlxG.log.warn(['Such alt animation doesnt exist: ' + AnimName]);
			#end
			AnimName = AnimName.split('-')[0];
		}

		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter.startsWith('gf'))
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
