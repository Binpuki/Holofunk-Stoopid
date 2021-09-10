#if sys
package;

import lime.app.Application;
#if windows
import Discord.DiscordClient;
#end
import openfl.display.BitmapData;
import openfl.utils.Assets;
import flixel.ui.FlxBar;
import haxe.Exception;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
#if cpp
import sys.FileSystem;
import sys.io.File;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

using StringTools;

class Caching extends MusicBeatState
{
	var toBeDone = 0;
	var done = 0;

	var loaded = false;

	var text:FlxText;
	var loadScreen:FlxSprite;
	var coolAssLoadingBar:FlxSprite;

	var barScale:Int = 1;

	var shitBeingCached:String = ''; //shit being cached

	public static var bitmapData:Map<String,FlxGraphic>;

	var images = [];
	var music = [];
	var charts = [];


	override function create()
	{

		FlxG.save.bind('funkin', 'ninjamuffin99');

		PlayerSettings.init();

		KadeEngineData.initSave();

		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0,0);

		bitmapData = new Map<String,FlxGraphic>();

		text = new FlxText(0, FlxG.height / 2 + 300,0,"caching ");
		text.size = 34;
		text.alignment = FlxTextAlign.LEFT;

		loadScreen = new FlxSprite(0, 0).loadGraphic(Paths.image('loading_screen'));

		if(FlxG.save.data.antialiasing != null)
			loadScreen.antialiasing = FlxG.save.data.antialiasing;
		else
			loadScreen.antialiasing = true;

		FlxGraphic.defaultPersist = FlxG.save.data.cacheImages;

		#if cpp
		if (FlxG.save.data.cacheImages)
		{
			trace("caching images...");

			for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/shared/images/characters")))
			{
				if (!i.endsWith(".png"))
					continue;
				images.push(i);
			}
		}

		trace("caching music...");

		for (i in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs")))
		{
			music.push(i);
		}
		#end

		toBeDone = Lambda.count(images) + Lambda.count(music);

		coolAssLoadingBar = new FlxSprite(0, FlxG.height - 75).makeGraphic(FlxG.width, 65, 0xFFE500FF);
		coolAssLoadingBar.visible = false;

		text.y = coolAssLoadingBar.y + (coolAssLoadingBar.height / 6);
		text.x = 0;

		add(loadScreen);
		add(coolAssLoadingBar);
		add(text);

		trace('starting caching..');
		
		#if cpp
		// update thread

		sys.thread.Thread.create(() -> {
			while(!loaded)
			{
				if (toBeDone != 0 && done != toBeDone)
					{
						text.text = "caching " + shitBeingCached + " (" + done + "/" + toBeDone + ")";

						var percent = Math.round(done / toBeDone * 100);
						coolAssLoadingBar.visible = true;
						coolAssLoadingBar.scale.x = percent / 100;
					}
			}
		
		});

		// cache thread

		sys.thread.Thread.create(() -> {
			cache();
		});
		#end

		super.create();
	}

	var calledDone = false;

	override function update(elapsed) 
	{
		super.update(elapsed);
	}


	function cache()
	{
		#if !linux
		trace("LOADING: " + toBeDone + " OBJECTS.");

		for (i in images)
		{
			shitBeingCached = i;
			var replaced = i.replace(".png","");
			var data:BitmapData = BitmapData.fromFile("assets/shared/images/characters/" + i);
			trace('id ' + replaced + ' file - assets/shared/images/characters/' + i + ' ${data.width}');
			var graph = FlxGraphic.fromBitmapData(data);
			graph.persist = true;
			graph.destroyOnNoUse = false;
			bitmapData.set(replaced,graph);
			done++;
		}

		for (i in music)
		{
			shitBeingCached = i;
			FlxG.sound.cache(Paths.inst(i));
			FlxG.sound.cache(Paths.voices(i));
			trace("cached " + i);
			done++;
		}


		trace("Finished caching...");

		loaded = true;

		trace(Assets.cache.hasBitmapData('GF_assets'));

		#end
		FlxG.switchState(new TitleState());
	}
}
#end