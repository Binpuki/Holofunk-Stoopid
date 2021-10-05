package deltarune;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;

class StageHandler
{
    var stage:String;
    public var sprites:FlxTypedGroup<FlxSprite>;

    public function new(stage:String)
    {
        this.stage = stage;
        sprites = new FlxTypedGroup<FlxSprite>();

        hardcodedStage(stage);
    }

    function hardcodedStage(stageGet:String)
    {
        switch (stageGet)
        {
            case 'pabloHappy':
			{
				var bg = new FlxSprite(-400, 0);
				bg.frames = Paths.getSparrowAtlas('stages/pabloHappy/bg', 'shared');
				bg.scrollFactor.set(0.4, 0.4);
				bg.antialiasing = true;
				bg.animation.addByPrefix('bg shit', 'background', 24, true);
				bg.animation.play('bg shit');
				sprites.add(bg);

				var backislands = new FlxSprite(-300, 200).loadGraphic(Paths.image('stages/pabloHappy/backislands', 'shared'));
				backislands.scrollFactor.set(0.6, 0.6);
				backislands.antialiasing = true;
				sprites.add(backislands);

                var kaigainiki = new FlxSprite(-200, 225);
                kaigainiki.scrollFactor.set(0.6, 0.6);
				kaigainiki.antialiasing = true;
                kaigainiki.frames = Paths.getSparrowAtlas('stages/pabloHappy/KaigaiNiki', 'shared');
                kaigainiki.animation.addByIndices('danceLeft', 'kaigai niki dance', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
                kaigainiki.animation.addByIndices('danceRight', 'kaigai niki dance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
                kaigainiki.animation.play('danceLeft');
                sprites.add(kaigainiki);

                var tako = new FlxSprite(250, 125);
                tako.scrollFactor.set(0.6, 0.6);
				tako.antialiasing = true;
                tako.frames = Paths.getSparrowAtlas('stages/pabloHappy/takodachi', 'shared');
                tako.animation.addByIndices('danceLeft', 'tako dance', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
                tako.animation.addByIndices('danceRight', 'tako dance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
                tako.animation.play('danceLeft');
                sprites.add(tako);

                var weirdbombcat = new FlxSprite(925, 140);
                weirdbombcat.scrollFactor.set(0.6, 0.6);
				weirdbombcat.antialiasing = true;
                weirdbombcat.frames = Paths.getSparrowAtlas('stages/pabloHappy/ssrbmin', 'shared');
                weirdbombcat.animation.addByIndices('danceLeft', 'ssrbmin dance', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
                weirdbombcat.animation.addByIndices('danceRight', 'ssrbmin dance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
                weirdbombcat.animation.play('danceLeft');
                sprites.add(weirdbombcat);

                var friend = new FlxSprite(-200, 225);
                friend.scrollFactor.set(0.6, 0.6);
				friend.antialiasing = true;
                friend.frames = Paths.getSparrowAtlas('stages/pabloHappy/friend', 'shared');
                friend.animation.addByIndices('danceLeft', 'mumay frien dance', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
                friend.animation.addByIndices('danceRight', 'mumay frien dance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
                friend.animation.play('danceLeft');
                sprites.add(friend);

				//the actual island
				var island = new FlxSprite(-100, 600).loadGraphic(Paths.image('stages/pabloHappy/mainislan', 'shared'));
				island.scrollFactor.set(0.95, 0.95);
				island.antialiasing = true;
				sprites.add(island);

				var backflower = new FlxSprite(20, 600).loadGraphic(Paths.image('stages/pabloHappy/backflower', 'shared'));
				backflower.scrollFactor.set(0.9, 0.9);
				backflower.antialiasing = true;
				sprites.add(backflower);

				//USED LIMO VARIABLE BC IM TOO LAZY TO CREATE NEW ONE FOR THE FRONT LOL
				var limo = new FlxSprite(0, 725).loadGraphic(Paths.image('stages/pabloHappy/frontflower', 'shared'));
				limo.scrollFactor.set(0.9, 0.9);
				limo.antialiasing = true;
                sprites.add(limo);
			}
            //whatever cases idk
            default:
            {
                txtStage(stageGet);
            }
        }
    }

    function txtStage(stageGet:String)
    {
        var awoo:Array<String> = CoolUtil.coolTextFile(Paths.txt('stageData/' + stageGet));
			
		for (i in 0...awoo.length) //Search for shit
		{
			var ina:Array<String> = awoo[i].split(':'); //SPLIT SHIT
		
			switch (ina[0])
			{
				case 'SPRITES':
					var poopoo = i + 1;
					var peepee:Array<String> = new Array<String>();

					for (ass in 0...awoo.length - poopoo)
					{
						peepee[ass] = awoo[poopoo + ass];
					}		

					loadStageShit(peepee);
					break;
			}
		}
    }

    //The text shit is really only for positioning things because I'm not recompiling the game 1000 times
	function loadStageShit(spriteData:Array<String>)
	{
		var ass:Array<String>;

		for (i in 0...spriteData.length)
		{
			ass = spriteData[i].split(':');

			var shit:FlxSprite;

			switch (ass[9]) //check animation
			{
				case 'packer':
					shit = new FlxSprite(Std.parseInt(ass[1]), Std.parseInt(ass[2]));
					shit.frames = Paths.getPackerAtlas(ass[7]);

					var frameThings:Array<String> = ass[11].split(',');
					var thingies:Array<Int> = new Array<Int>();
					for (j in 0...frameThings.length)
					{
						thingies[j] = Std.parseInt(frameThings[j]);
					}

					shit.animation.add(ass[10], thingies, Std.parseInt(ass[12]));

				case 'sparrow':
					shit = new FlxSprite(Std.parseInt(ass[1]), Std.parseInt(ass[2]));
					shit.frames = Paths.getSparrowAtlas(ass[7]);

					var loopBool = false;
					if (ass[13] == 'true')
						loopBool = true;

					shit.animation.addByPrefix(ass[10], ass[11], Std.parseInt(ass[12]), loopBool);

				default:
					shit = new FlxSprite(Std.parseInt(ass[1]), Std.parseInt(ass[2])).loadGraphic(Paths.image(ass[7]));
			}

			var ISITPIXEL:Bool;

			if (ass[9] == 'true')
				ISITPIXEL = true;
			else
				ISITPIXEL = false;

			if (ass[6] == 'true') //CHECK PIXEL SHIT IS TRUE
			{
				shit.setGraphicSize(Std.int(shit.width * PlayState.daPixelZoom));
				shit.updateHitbox();
			}
			else 
			{
				if (ass[6] != 'false')
				{
					trace("RESIZE "  + ass[0] + " TO " + ass[6]);
					shit.setGraphicSize(Std.int(shit.width * Std.parseInt(ass[6])));
					shit.updateHitbox();
				}
			}

			shit.setGraphicSize(Std.int(shit.width * Std.parseFloat(ass[5])));
			shit.updateHitbox();

			if (ass[6] == 'true' || ISITPIXEL)
				shit.antialiasing = false;
			else
				shit.antialiasing = FlxG.save.data.antialiasing;

			shit.scrollFactor.set(Std.parseFloat(ass[3]), Std.parseFloat(ass[4]));
			shit.active = false;

			if (ass[8] == 'false')
				shit.visible = false;
			else
				shit.visible = true;

			if (ass[9] == 'packer' || ass[9] == 'sparrow')
			{
				shit.animation.play(ass[10]);
			}

			sprites.add(shit);
		}
	}
}