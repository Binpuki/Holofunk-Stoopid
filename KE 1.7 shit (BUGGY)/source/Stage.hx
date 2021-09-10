package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.util.FlxColor;

class Stage
{
	//PUKI CODE
	//X AND Y
    public var bfOffset:Array<Int> = [0, 0];
    public var dadOffset:Array<Int> = [0, 0];
    public var gfOffset:Array<Int> = [0, 0];

	public var date:Bool; //Whether to put the "3 2 1 GO!" or "3 2 1 DATE!"

	//KADE CODE
    public var curStage:String;
    public var halloweenLevel:Bool = false;
    public var camZoom:Float;
    public var hideLastBG:Bool = false; // True = hide last BG and show ones from slowBacks on certain step, False = Toggle Visibility of BGs from SlowBacks on certain step
    public var tweenDuration:Float = 2; // How long will it tween hiding/showing BGs, variable above must be set to True for tween to activate
    public var toAdd:Array<Dynamic> = []; // Add BGs on stage startup, load BG in by using "toAdd.push(bgVar);"
    // Layering algorithm for noobs: Everything loads by the method of "On Top", example: You load wall first(Every other added BG layers on it), then you load road(comes on top of wall and doesn't clip through it), then loading street lights(comes on top of wall and road)
    public var swagBacks:Map<String, Dynamic> = []; // Store BGs here to use them later in PlayState or when slowBacks activate
    public var swagGroup:Map<String, FlxTypedGroup<Dynamic>> = []; //Store Groups
    public var animatedBacks:Array<FlxSprite> = []; // Store animated backgrounds and make them play animation(Animation must be named Idle!! Else use swagGroup)
    public var layInFront:Array<Array<FlxSprite>> = [[], [], []]; // BG layering, format: first [0] - in front of GF, second [1] - in front of opponent, third [2] - in front of boyfriend(and techincally also opponent since Haxe layering moment)
    public var slowBacks:Map<Int, Array<FlxSprite>> = []; // Change/add/remove backgrounds mid song! Format: "slowBacks[StepToBeActivated] = [Sprites,To,Be,Changed,Or,Added];"

    public function new(daStage:String)
    {
        this.curStage = daStage;
        camZoom = 1.05; // Don't change zoom here, unless you want to change zoom of every stage that doesn't have custom one
        halloweenLevel = false;

		//ALRIGHT BITCHES PUKI CODE
		bfOffset = new Array<Int>();
		gfOffset = new Array<Int>();
		dadOffset = new Array<Int>();

		//TIME TO LOAD SHIT
		//SOME THINGS ARE HARDCODED BECAUSE IM FUCKING LAZY RN LOL
		//THE TXT SHIT IS JUST BECAUSE IM NOT RECOMPILING THE GAME EVERY TIME I GET SMTH WRONG
		switch (curStage)
		{
			case 'limonight':
			{
				curStage = 'limo';
				camZoom = 0.90;
	
				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('stages/limonight/limoNight','shared'));
				skyBG.scrollFactor.set(0.1, 0.1);
				skyBG.antialiasing = FlxG.save.data.antialiasing;
				swagBacks['skyBG'] = skyBG;
				toAdd.push(skyBG);
	
				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('stages/limonight/aloeLimo','shared');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				bgLimo.antialiasing = FlxG.save.data.antialiasing;
				swagBacks['bgLimo'] = bgLimo;
                toAdd.push(bgLimo);

				var fastCar:FlxSprite;
				fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('stages/limonight/fastCarLol','shared'));
				if(FlxG.save.data.distractions){
					var grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
					swagGroup['grpLimoDancers'] = grpLimoDancers;
                    toAdd.push(grpLimoDancers);
		
					for (i in 0...5)
					{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
					}

					swagBacks['fastCar'] = fastCar;
               		layInFront[2].push(fastCar);
				}
	
				var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('stages/limonight/limoOverlay','shared'));
				overlayShit.alpha = 0.5;
				// add(overlayShit);
	
				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);
	
				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);
	
				// overlayShit.shader = shaderBullshit;
	
				var limoTex = Paths.getSparrowAtlas('stages/limonight/limoDrive','shared');
	
				var limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = FlxG.save.data.antialiasing;
				layInFront[0].push(limo);
                swagBacks['limo'] = limo;
				// add(limo);
			}

			//x0o0x ------ SECTION

			case 'x0o0x-box1':
			{
				curStage = 'x0o0x-box1';
				camZoom = 0.60;

				//THE BACKGROUND SHIT
				var backgroundShit = new FlxTypedGroup<FlxSprite>();
				swagGroup['backgroundShit'] = backgroundShit;
				toAdd.push(backgroundShit);

				var whiteBg:FlxSprite = new FlxSprite(-(FlxG.width * 1.5), -(FlxG.height * 1.5)).makeGraphic(FlxG.width * 4, FlxG.height * 4, FlxColor.fromRGB(123, 132, 132));
				whiteBg.alpha = 0; //Flashing shit
				backgroundShit.add(whiteBg);

				//COOL BOX SHIT
				var coolBox:FlxSprite = new FlxSprite(-60, -60).loadGraphic(Paths.image('stages/x0o0x-box1/coolAssBox', 'shared'));
				coolBox.scrollFactor.set(1, 1);
				coolBox.setGraphicSize(Std.int(coolBox.width * 6));
				coolBox.updateHitbox();
				coolBox.antialiasing = false;
				toAdd.push(coolBox);

				var animGroupShit = new FlxTypedGroup<BackgroundDancer>();
				swagGroup['animOne'] = animGroupShit;
				toAdd.push(animGroupShit);

				//box anim 1 (the shit at the bottom)
				var coolAnimOne:BackgroundDancer = new BackgroundDancer(-60, -60, 'stages/x0o0x-box1/coolAnim1', 'ANIM 1 loop');
				coolAnimOne.scrollFactor.set(1, 1);
				coolAnimOne.setGraphicSize(Std.int(coolAnimOne.width * 6));
				coolAnimOne.updateHitbox();
				coolAnimOne.antialiasing = false;
				animGroupShit.add(coolAnimOne);

				//box anim 2 (the shit at the top) (FINISH THE SHIT FIRST)
				var animGroupShit2 = new FlxTypedGroup<BackgroundDancer>();
				swagGroup['animTwo'] = animGroupShit2;
				toAdd.push(animGroupShit2);

				var coolAnimTwo:BackgroundDancer = new BackgroundDancer(-60, -60, 'stages/x0o0x-box1/coolAnim2', 'ANIM 2 loop');
				coolAnimTwo.scrollFactor.set(1, 1);
				coolAnimTwo.setGraphicSize(Std.int(coolAnimTwo.width * 6));
				coolAnimTwo.updateHitbox();
				coolAnimTwo.antialiasing = false;
				animGroupShit2.add(coolAnimTwo);
				
			}

			//TXT SECTION
			default:
			{
				var awoo:Array<String> = CoolUtil.coolTextFile(Paths.txt('data/stageData/' + curStage));
			
				for (i in 0...awoo.length) //Search for shit
				{
					var ina:Array<String> = awoo[i].split(':'); //SPLIT SHIT
			
					switch (ina[0])
					{
						case 'stage':
							curStage = ina[1];
						case 'zoom':
							camZoom = Std.parseFloat(ina[1]);
						case 'bfOffset':
							bfOffset[0] = Std.parseInt(ina[1]);
							bfOffset[1] = Std.parseInt(ina[2]);
						case 'gfOffset':
							gfOffset[0] = Std.parseInt(ina[1]);
							gfOffset[1] = Std.parseInt(ina[2]);
						case 'dadOffset':
							dadOffset[0] = Std.parseInt(ina[1]);
							dadOffset[1] = Std.parseInt(ina[2]);
						case 'SPRITES':
							var poopoo = i + 1;
							var peepee:Array<String> = new Array<String>();

							for (ass in 0...awoo.length - poopoo)
							{
								peepee[ass] = awoo[poopoo + ass];
							}		

							loadSprites(peepee);
							break;
					}
				}
			}
		}
    }

	function loadSprites(spriteData:Array<String>)
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

			swagBacks[ass[0]] = shit;
			toAdd.push(shit);

			if (ass[9] == 'packer' || ass[9] == 'sparrow')
			{
				shit.animation.play(ass[10]);
				animatedBacks.push(shit);
			}
		}
	}
}