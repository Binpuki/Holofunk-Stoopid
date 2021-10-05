package;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import MP4Handler;

//Originally made by polybiusproxy, i just converted it into state because im stupid lol

class MP4State extends FlxState
{
    //State that handles the mp4 thingamajig
    public var video:MP4Handler;
    public static var path:String;
    public static var stateSwitch:FlxState;

    //PAUSE SCREEN
    var pauseBlack:FlxSprite;
    var pauseText:FlxText;
    var paused:Bool = false;

    override public function create()
    {
        video = new MP4Handler();
        video.playMP4(path, stateSwitch);

        //pause shit
        pauseBlack = new FlxSprite(0, 0).makeGraphic(1280, 720, FlxColor.BLACK);
        pauseBlack.alpha = 0.30;

        var text = "VIDEO PAUSED\n\nPress [P] again to unpause.\nPress [Space] to Skip";
		pauseText = new FlxText(0, 0, FlxG.width, text, 32);
		pauseText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		pauseText.screenCenter();

        super.create();
    }

    var htmlPlaying = true;

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.P)
        {
            trace('paused');

            if (!paused)
            {
                add(pauseBlack);
                add(pauseText);
                paused = true;
            }
            else
            {
                remove(pauseBlack);
                remove(pauseText);
                paused = false;
            }

            #if html5
            if (htmlPlaying)
            {
                video.netStream.pause();
                htmlPlaying = false;
            }
            else
            {
                video.netStream.resume();
                htmlPlaying = true;
            }
            #else
            if (video.vlcPlaying)
            {
                video.vlcBitmap.pause();
            }
            else
            {
                video.vlcBitmap.resume();
            }
            #end
        }

        super.update(elapsed);
    }
}