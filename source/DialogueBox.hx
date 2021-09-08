package;

import flixel.system.FlxSound;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import CoolUtil;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var curName:String = 'Senpai'; //Current name for character

	//Customizable shit
	var sound:FlxSound;
	var box:FlxSprite;
	var soundOpenPath:String;

	var portraitPointers:Array<String>;
	var portraitNames:Array<String>;
	var portraitIsPixel:Array<Bool>;
	var portraitExp:Array<Array<FlxSprite>>;

	var portraitXPos:Array<Int>;
	var portraitYPos:Array<Int>;

	var currentName:FlxText;

	var behindBox:FlxSprite;
	var current_exp:Int = 0;

	public var fadeColor:FlxColor = FlxColor.BLACK;
	public var fadeBool:Bool = false;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		box = new FlxSprite(-20, 45);

		getStartShit(PlayState.SONG.song);
		var newthing = getPortraitShit(dialogueList);


		if (sound != null)
		{
			sound.volume = 0;
			FlxG.sound.list.add(sound);
			sound.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		behindBox = new FlxSprite(0, 0).loadGraphic(Paths.image('UI/pixel/nameBox'));
		behindBox.setGraphicSize(Std.int(behindBox.width * 6));
		behindBox.updateHitbox();
		behindBox.screenCenter();
		behindBox.x -= (46 * PlayState.daPixelZoom);
		behindBox.y += (8 * PlayState.daPixelZoom);
		behindBox.alpha = 0.6;

		this.dialogueList = newthing;
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		currentName = new FlxText(behindBox.x + (behindBox.width / 2), behindBox.y + (2 * PlayState.daPixelZoom), Std.int(behindBox.width * 0.8), "Senpai", 32);
		currentName.setFormat("Pixel Arial 11 Bold", 32, FlxColor.BLACK, LEFT);

		if (!PlayState.Stage.curStage.startsWith('school')){
			box.y = -(26 * PlayState.daPixelZoom);
			box.x = (13 * PlayState.daPixelZoom);
			add(behindBox);
			add(currentName);
		}

		box.screenCenter(X);

		//handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		//add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{

		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.visible = false;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (sound != null)
						sound.fadeOut(2.2, 0);
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];

		trace(curCharacter);

		var current_ID:Int = 0;
		for (i in 0...portraitPointers.length)
		{
			if (portraitPointers[i] == curCharacter)
			{
				current_ID = i;
				break;
			}
		}

		//Remove all portrait expressions
		for (i in 0...portraitExp.length)
		{
			for (j in 0...portraitExp[i].length)
			{
				remove(portraitExp[i][j]);
			}
		}

		remove(behindBox);
		remove(currentName);

		currentName.text = portraitNames[current_ID];
		currentName.x = behindBox.x + (behindBox.width / 2) - (currentName.size / 2);

		add(portraitExp[current_ID][Std.parseInt(splitName[2])]);
		add(behindBox);
		add(currentName);

		dialogueList[0] = dialogueList[0].substr(splitName[1].length + splitName[2].length + 3).trim();
	}

	function getStartShit(songName:String)
	{
		var songLowercase:String = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();

		var settings:Array<String> = CoolUtil.coolTextFile(Paths.txt('data/songs/' + songLowercase + '/dialogueSettings'));

		for (i in 0...settings.length)
		{
			var oreo_milkshake:Array<String> = settings[i].split(':');

			/*
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
				*/

			switch (oreo_milkshake[0])
			{
				case 'song':
					sound = new FlxSound().loadEmbedded(Paths.music(oreo_milkshake[1]),true);

				case 'boxPath':
					box.frames = Paths.getSparrowAtlas(oreo_milkshake[1], 'shared', false);

				case 'dialogueBoxAppear':
					if (oreo_milkshake[3] == null)
						box.animation.addByPrefix('normalOpen', oreo_milkshake[1], Std.parseInt(oreo_milkshake[2]), false);
					else
						box.animation.addByIndices('normalOpen', oreo_milkshake[1], [Std.parseInt(oreo_milkshake[3])], "", Std.parseInt(oreo_milkshake[2]));

				case 'dialogueBox':
					if (oreo_milkshake[3] == null)
						box.animation.addByPrefix('normal', oreo_milkshake[1], Std.parseInt(oreo_milkshake[2]));
					else
						box.animation.addByIndices('normal', oreo_milkshake[1], [Std.parseInt(oreo_milkshake[3])], "", Std.parseInt(oreo_milkshake[2]));

				case 'fadeFrom':
					fadeColor = FlxColor.fromRGB(Std.parseInt(oreo_milkshake[1]), Std.parseInt(oreo_milkshake[2]), Std.parseInt(oreo_milkshake[3]));
					fadeBool = true;

				case 'soundOpen':
					if (oreo_milkshake[1] != 'none')
						soundOpenPath = oreo_milkshake[1];
			}
		}
	}

	function getPortraitShit(dialogue:Array<String>):Array<String>
	{
		//LOAD PORTRAIT SHIT
		var songName:String = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();

		portraitPointers = new Array<String>();
		portraitNames = new Array<String>();
		portraitIsPixel = new Array<Bool>();
		portraitExp = new Array<Array<FlxSprite>>();

		portraitXPos = new Array<Int>();
		portraitYPos = new Array<Int>();

		var newDialogue:Array<String> = ['smth bronk ;('];

		var picNum:Int = 0;
		
		for (i in 0...dialogue.length)
		{
			var splitShit:Array<String> = dialogue[i].split(':');

			switch (splitShit[0])
			{
				case 'load':
				{
					for (j in 0...splitShit.length)
					{
						if (j != 0)
						{
							var curNum = j - 1;
							var ingameName:String = splitShit[j];
							portraitPointers[curNum] = ingameName;

							var cock:Array<String> = CoolUtil.coolTextFile(Paths.txt('data/portraitData/' + ingameName));

							//ANOTHER for statement god damn
							for (balls in 0...cock.length)
							{
								var ass:Array<String> = cock[balls].split(':');

								switch (ass[0])
								{
									case 'name':
										portraitNames[curNum] = ass[1];

									case 'pixel':
										if (ass[1] == 'yes')
										{
											portraitIsPixel[curNum] = true;
										}
										else 
										{
											portraitIsPixel[curNum] = false;
										}
									
									case 'xPos':
										portraitXPos[curNum] = Std.parseInt(ass[1]);

									case 'yPos':
										portraitYPos[curNum] = Std.parseInt(ass[1]);

									case 'picAmount':
									{
										picNum = Std.parseInt(ass[1]);

										portraitExp[curNum] = new Array<FlxSprite>();
										
										//god damn
										for (e in 0...picNum)
										{
											portraitExp[curNum][e] = new FlxSprite(0, 0).loadGraphic(Paths.image('portraits/' + portraitPointers[curNum] + '/' + e));

											if (portraitIsPixel[curNum])
											{
												portraitExp[curNum][e].setGraphicSize(Std.int(portraitExp[curNum][e].width * PlayState.daPixelZoom * 0.9));
												portraitExp[curNum][e].updateHitbox();
											}

											portraitExp[curNum][e].updateHitbox();
											portraitExp[curNum][e].screenCenter();

											portraitExp[curNum][e].x += portraitXPos[curNum];
											portraitExp[curNum][e].y += portraitYPos[curNum];
										}
									}
								}
							}
						}
					}
				}

				case 'DIALOGUE':
				{
					for (j in 0...dialogue.length - i)
					{
						newDialogue[j] = dialogue[i + j + 1];
					}
					break;
				}
			}
		}

		return newDialogue;
	}
}
