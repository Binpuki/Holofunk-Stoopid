package deltarune;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using StringTools;

class DeltaruneAlphabet
{
    //For the health icon fitting n shit

    var rawText:Array<String>;

    public var textSprites:Array<FlxText> = [];
    public var iconSprites:Array<HealthIcon> = [];

    public var x:Int;
    public var y:Int;

    var currentX:Int = 0;

    public var group:FlxSpriteGroup;

    public function new(x:Int, y:Int)
    {
       this.x = x;
       this.y = y;

       currentX = x;
       group = new FlxSpriteGroup();
    }  

    public function setGroup()
    {
        for (i in 0...textSprites.length)
        {
            group.add(textSprites[i]);
        }

        for (i in 0...iconSprites.length)
        {
            group.add(iconSprites[i]);
        }

        return group;
    }

    public function setText(string:Array<String>)
    {
        rawText = string;

        for (i in 0...rawText.length)
        {
            if (rawText[i].startsWith('icon:'))
            {
                var whereThingy = rawText[i].indexOf(':') + 1;
                var poop = rawText[i].substr(whereThingy, rawText[i].length);

                createIcon(currentX, y, poop);
            }

            if (rawText[i].startsWith('text:'))
            {
                var whereThingy = rawText[i].indexOf(':') + 1;
                var poop = rawText[i].substr(whereThingy, rawText[i].length);

                createText(currentX, y, poop);
            }
        }
    }

    
    public function updatePosition(change:FlxPoint)
    {
        for (i in 0...textSprites.length)
        {
            textSprites[i].x += Std.int(change.x);
            textSprites[i].y += Std.int(change.y);
        }

        for (i in 0...iconSprites.length)
        {
            iconSprites[i].x += Std.int(change.x);
            iconSprites[i].y += Std.int(change.y);
        }

        x += Std.int(change.x);
        y += Std.int(change.y);
    }

    var textOffset:FlxPoint = new FlxPoint(10, -1);

    function createText(_x:Int, _y:Int, text:String)
    {
        var currentThingy = textSprites.length;
        textSprites[currentThingy] = new FlxText(_x + textOffset.x, _y + textOffset.y, 0, text, 30);
        textSprites[currentThingy].font = 'Pixel Arial 11 Bold';
        textSprites[currentThingy].color = FlxColor.WHITE;
        currentX += Std.int(textSprites[currentThingy].width);
    }

    var iconOffset:FlxPoint = new FlxPoint(15, -14);

    function createIcon(_x:Int, _y:Int, char:String)
    {
        var currentThingy = iconSprites.length;
        iconSprites[currentThingy] = new HealthIcon(char);
        iconSprites[currentThingy].x = _x + iconOffset.x;
        iconSprites[currentThingy].y = _y + iconOffset.y;
        iconSprites[currentThingy].setGraphicSize(Std.int(iconSprites[currentThingy].frameWidth * (0.5)));
        iconSprites[currentThingy].updateHitbox();

        currentX += Std.int(iconSprites[currentThingy].width);
    }
}