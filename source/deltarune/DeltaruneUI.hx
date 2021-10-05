package deltarune;

import flixel.addons.text.FlxTypeText;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;

using StringTools;

class DeltaruneUI extends FlxSpriteGroup
{
    var icons:Array<HealthIcon> = [];
    var nameText:Array<FlxText> = [];

    var healthText:Array<FlxText> = [];
    var healthString:Array<String> = [];
    var healthSprite:Array<FlxSprite> = [];
    var healthRed:Array<FlxSprite> = [];

    var regHealthWidth:Int = 0;
    var regHealthX:Array<Int> = [];

    var playboxOutline:Array<FlxSprite> = [];
    var playerBoxes:Array<FlxSprite> = [];
    var playboxUnderline:Array<FlxSprite> = [];

    //OPTIONS SHIT
    var playerOptions:Array<Array<FlxSprite>> = [];

    //TEXT SHIT
    var staticHPText:Array<FlxText> = [];

    var bottomText:FlxTypeText;

    var coolOutlineColorThingyThatImTooLazyToTypeOutBecauseImDummy:FlxColor;

    var bottomRectangle:FlxSprite;
    public var bottomOutline:FlxSprite;

    var upperRectangle:FlxSprite;
    var upperOutline:FlxSprite;

    var outlineThingy:Int;

    var magicText:Array<DeltaruneAlphabet> = [];

    public function new(amtOfPlayers:Int)
    {
        super();

        coolOutlineColorThingyThatImTooLazyToTypeOutBecauseImDummy = FlxColor.fromRGB(38, 29, 36);

        outlineThingy = 5;

        var resizeBottom = 40;

        bottomRectangle = new FlxSprite(0, FlxG.height + outlineThingy).makeGraphic(FlxG.width, Std.int(FlxG.height * (1 / 6)) + resizeBottom, FlxColor.BLACK);
        bottomOutline = new FlxSprite(0, FlxG.height).makeGraphic(FlxG.width, Std.int(FlxG.height * (1 / 6)) + resizeBottom, coolOutlineColorThingyThatImTooLazyToTypeOutBecauseImDummy);

        upperRectangle = new FlxSprite(0, FlxG.height + outlineThingy).makeGraphic(FlxG.width, Std.int(FlxG.height * (1 / 6)) + resizeBottom, FlxColor.BLACK);
        upperOutline = new FlxSprite(0, FlxG.height).makeGraphic(FlxG.width, Std.int(FlxG.height * (1 / 6)) + resizeBottom, coolOutlineColorThingyThatImTooLazyToTypeOutBecauseImDummy);

        //Player boxes n shit
        var resizeThingy = 30;
        for (i in 0...amtOfPlayers)
        {
            playerBoxes[i] = new FlxSprite(0, 0).makeGraphic(Std.int((FlxG.width * (1 / 3)) - resizeThingy), 300, FlxColor.BLACK);
            playboxOutline[i] = new FlxSprite(0, 0).makeGraphic(Std.int(playerBoxes[i].width + (outlineThingy * 2)), Std.int(playerBoxes[i].height), DeltaruneState.playerColors[i]);
            playboxUnderline[i] = new FlxSprite(0, 0).makeGraphic(Std.int(playerBoxes[i].width + (outlineThingy * 2)), outlineThingy, DeltaruneState.playerColors[i]);
            playboxOutline[i].alpha = 0;

            var threePeeps:Array<Int> = [Std.int((FlxG.width * (1 / 3)) - (resizeThingy / 2)), Std.int((FlxG.width * (2 / 3)) - (resizeThingy / 2)), Std.int((FlxG.width * ((1 / 3) * 3)) - (resizeThingy / 2))];
            var twoPeeps:Array<Int> = [Std.int(threePeeps[1] - (playerBoxes[i].width * (1 / 2)) - (resizeThingy / 2)), Std.int(threePeeps[1] + (playerBoxes[i].width * (1 / 2)) + (resizeThingy / 2))];

            switch (amtOfPlayers)
            {
                case 1:
                {
                    playerBoxes[i].x = threePeeps[1] - (playerBoxes[i].width);
                }
                case 2:
                {
                    playerBoxes[i].x = twoPeeps[i] - (playerBoxes[i].width);
                }
                default:
                {
                    playerBoxes[i].x = threePeeps[i] - (playerBoxes[i].width);
                }
            }

            playboxOutline[i].x = playerBoxes[i].x - (outlineThingy);
            playboxUnderline[i].x = playerBoxes[i].x - (outlineThingy);
            playboxOutline[i].y = FlxG.height;
            playboxUnderline[i].y = FlxG.height;
            playerBoxes[i].y = FlxG.height;

            //MAKE THE ICONS TOO
            icons[i] = new HealthIcon(DeltaruneState.playerIndex[i]);
            icons[i].x = playerBoxes[i].x;
            icons[i].y = FlxG.height;

            icons[i].setGraphicSize(Std.int(icons[i].frameWidth * (0.5)));
            icons[i].updateHitbox();

            //AND NOW THE NAMES
            nameText[i] = new FlxText(Std.int(playerBoxes[i].x + 70), FlxG.height, Std.int(playerBoxes[i].width), DeltaruneState.playerNames[i], 30);
            nameText[i].font = 'Pixel Arial 11 Bold';
		    nameText[i].color = FlxColor.WHITE;
            nameText[i].antialiasing = false;

            //AND NOW FOR THE HEALTH THINGIES
            var healthResize:Int = 24;
            var howwidethingyshouldbe = Std.int((playerBoxes[i].width / 2) - (healthResize * 2));
            var wherethingyshouldbe = Std.int(playerBoxes[i].x + (playerBoxes[i].width / 2) + 36);
            var howtallthingyshouldbe = 18;
            healthSprite[i] = new FlxSprite(wherethingyshouldbe, FlxG.height).makeGraphic(howwidethingyshouldbe, howtallthingyshouldbe, DeltaruneState.playerColors[i]);

            regHealthWidth = howwidethingyshouldbe;
            regHealthX[i] = wherethingyshouldbe;

            healthRed[i] = new FlxSprite(wherethingyshouldbe, FlxG.height).makeGraphic(howwidethingyshouldbe, howtallthingyshouldbe, FlxColor.fromRGB(121, 0, 2));
            
            //STATIC HP TEXT
            staticHPText[i] = new FlxText(wherethingyshouldbe - (healthResize) - 15, FlxG.height, Std.int(playerBoxes[i].width / 2), "HP", 18);
            staticHPText[i].font = 'Pixel Arial 11 Bold';
		    staticHPText[i].color = FlxColor.WHITE;
            staticHPText[i].alignment = LEFT;

            //HP TEXT
            healthString[i] = Std.string(DeltaruneState.health[i]) + " / " + Std.string(DeltaruneState.healthLimit[i]);
            healthText[i] = new FlxText(wherethingyshouldbe + 4, FlxG.height, healthRed[i].width, healthString[i], 18);
            healthText[i].font = 'Pixel Arial 11 Bold';
            healthText[i].color = FlxColor.WHITE;
            healthText[i].alignment = RIGHT;

            //OPTIONS SHIT
            playerOptions[i] = new Array<FlxSprite>();
            var cock = DeltaruneState.choices[i];
            for (poop in 0...cock.length)
            {
                playerOptions[i][poop] = new FlxSprite(playerBoxes[i].x + (75 * poop) + 18, FlxG.height);
                playerOptions[i][poop].frames = Paths.getSparrowAtlas('deltarune/DeltaruneUI', 'pablo');
                playerOptions[i][poop].animation.addByIndices('unhover', DeltaruneState.choices[i][poop], [0], "", 24, false);
                playerOptions[i][poop].animation.addByIndices('hover', DeltaruneState.choices[i][poop], [1], "", 24, false);
                playerOptions[i][poop].animation.play('unhover');
            }
        }

        updateOption(DeltaruneState.selectedPlayer, DeltaruneState.selectedOption);

        //BOTTOM TEXT
        bottomText = new FlxTypeText(bottomRectangle.x + 30, FlxG.height, Std.int(FlxG.width * 0.85), "", 30);
        bottomText.font = 'Pixel Arial 11 Bold';
        bottomText.sounds = [FlxG.sound.load(Paths.sound('pixelText', 'shared'), 0.6)];
        bottomText.alignment = LEFT;
        bottomText.color = FlxColor.WHITE;

        //Layering n shit

        add(upperOutline);
        add(upperRectangle);

        for (i in 0...playerBoxes.length)
        {
            add(playboxOutline[i]);
            add(playerBoxes[i]);
            add(playboxUnderline[i]);
            add(icons[i]);
            add(nameText[i]);
            add(healthRed[i]);
            add(healthSprite[i]);
            add(staticHPText[i]);
            add(healthText[i]);

            for (j in 0...playerOptions[i].length)
            {
                add(playerOptions[i][j]);
            }
        }

        add(bottomOutline);
        add(bottomRectangle);
        add(bottomText);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    public function showUI(?noShow:Array<Int>)
    {
        FlxTween.tween(bottomOutline, {y: FlxG.height - bottomOutline.height - 5}, 0.2, {ease: FlxEase.quadOut});
        FlxTween.tween(bottomRectangle, {y: FlxG.height - bottomOutline.height}, 0.2, {ease: FlxEase.quadOut});

        var upperOffsetthingy = 75;
        var upperGoTo = (FlxG.height - bottomOutline.height) - upperOffsetthingy;

        FlxTween.tween(upperOutline, {y: upperGoTo - outlineThingy}, 0.2, {ease: FlxEase.quadOut});
        FlxTween.tween(upperRectangle, {y: upperGoTo}, 0.2, {ease: FlxEase.quadOut});

        var playerNum = playerBoxes.length;
        for (i in 0...playerNum)
        {
            var bringUp:Bool = true;

            if (noShow != null)
            {
                for (j in 0...noShow.length)
                {
                    if (i == noShow[j])
                        bringUp = false;
                }
            }

            if (bringUp)
            {
                FlxTween.tween(playerBoxes[i], {y: (upperGoTo)}, 0.2, {ease: FlxEase.quadOut});
                FlxTween.tween(icons[i], {y: (upperGoTo)}, 0.18, {ease: FlxEase.quadOut});
                FlxTween.tween(healthSprite[i], {y: (upperGoTo + 40)}, 0.18, {ease: FlxEase.quadOut});
                FlxTween.tween(healthRed[i], {y: (upperGoTo + 40)}, 0.18, {ease: FlxEase.quadOut});
                FlxTween.tween(healthText[i], {y: (upperGoTo + 11)}, 0.18, {ease: FlxEase.quadOut});
                FlxTween.tween(staticHPText[i], {y: (upperGoTo + 35)}, 0.18, {ease: FlxEase.quadOut});
                FlxTween.tween(nameText[i], {y: (upperGoTo + 10)}, 0.18, {ease: FlxEase.quadOut});
                FlxTween.tween(playboxOutline[i], {y: (upperGoTo - outlineThingy)}, 0.2, {ease: FlxEase.quadOut});
                FlxTween.tween(playboxUnderline[i], {y: FlxG.height - bottomOutline.height}, 0.18, {ease: FlxEase.quadOut});
                        
                for (ass in 0...playerOptions[i].length)
                {
                    FlxTween.tween(playerOptions[i][ass], {y: FlxG.height - bottomOutline.height}, 0.18, {ease: FlxEase.quadOut});
                }
            }
        }

        FlxTween.tween(bottomText, {y: FlxG.height - bottomRectangle.height + 15}, 0.2, {ease:FlxEase.quadOut});
    }

    public function hideUI()
    {
        FlxTween.tween(bottomOutline, {y: FlxG.height}, 0.2, {ease: FlxEase.quadOut});
        FlxTween.tween(bottomRectangle, {y: FlxG.height}, 0.2, {ease: FlxEase.quadOut});

        //im lazy lol
        var upperOffsetthingy = 75;
        var upperGoTo = (FlxG.height) - upperOffsetthingy;

        FlxTween.tween(upperOutline, {y: upperGoTo - outlineThingy}, 0.2, {ease: FlxEase.quadOut});
        FlxTween.tween(upperRectangle, {y: upperGoTo}, 0.2, {ease: FlxEase.quadOut});

        var playerNum = playerBoxes.length;
        for (i in 0...playerNum)
        {
            FlxTween.tween(playerBoxes[i], {y: (upperGoTo)}, 0.2, {ease: FlxEase.quadOut});
            FlxTween.tween(icons[i], {y: (upperGoTo)}, 0.18, {ease: FlxEase.quadOut});
            FlxTween.tween(healthSprite[i], {y: (upperGoTo + 40)}, 0.18, {ease: FlxEase.quadOut});
            FlxTween.tween(healthRed[i], {y: (upperGoTo + 40)}, 0.18, {ease: FlxEase.quadOut});
            FlxTween.tween(healthText[i], {y: (upperGoTo + 11)}, 0.18, {ease: FlxEase.quadOut});
            FlxTween.tween(staticHPText[i], {y: (upperGoTo + 35)}, 0.18, {ease: FlxEase.quadOut});
            FlxTween.tween(nameText[i], {y: (upperGoTo + 10)}, 0.18, {ease: FlxEase.quadOut});
            FlxTween.tween(playboxOutline[i], {y: (upperGoTo - outlineThingy)}, 0.2, {ease: FlxEase.quadOut});
            FlxTween.tween(playboxUnderline[i], {y: FlxG.height}, 0.18, {ease: FlxEase.quadOut});
            
            for (ass in 0...playerOptions[i].length)
            {
                FlxTween.tween(playerOptions[i][ass], {y: FlxG.height}, 0.18, {ease: FlxEase.quadOut});
            }
        }

        FlxTween.tween(bottomText, {y: FlxG.height}, 0.2, {ease:FlxEase.quadOut});
    }

    public function selectChar(player:Int)
    {
        try
        {
            var time:Float = 0.2;
            var upperOffsetthingy = 75;
            var wherego = (FlxG.height - bottomOutline.height) - (upperOffsetthingy * 2);
            FlxTween.tween(playboxOutline[player], {y: wherego - 10, alpha: 1}, time, {ease: FlxEase.quadOut});
            FlxTween.tween(playerBoxes[player], {y: wherego - outlineThingy}, time, {ease: FlxEase.quadOut});
            FlxTween.tween(healthSprite[player], {y: wherego + 40 - outlineThingy}, time - 0.02, {ease: FlxEase.quadOut});
            FlxTween.tween(healthRed[player], {y: wherego + 40 - outlineThingy}, time - 0.02, {ease: FlxEase.quadOut});
            FlxTween.tween(healthText[player], {y: wherego + 11 - outlineThingy}, time - 0.02, {ease: FlxEase.quadOut});
            FlxTween.tween(staticHPText[player], {y: wherego + 35 - outlineThingy}, time - 0.02, {ease: FlxEase.quadOut});
            FlxTween.tween(nameText[player], {y: wherego + 10 - outlineThingy}, time - 0.02, {ease: FlxEase.quadOut});
            FlxTween.tween(icons[player], {y: wherego - outlineThingy}, time - 0.02, {ease: FlxEase.quadOut});
            FlxTween.tween(playboxUnderline[player], {alpha: 1, y: FlxG.height - bottomOutline.height - upperOffsetthingy - outlineThingy}, time - 0.02, {ease: FlxEase.quadOut});

            var choices_y = FlxG.height - bottomOutline.height - upperOffsetthingy - (outlineThingy * 2) + 12;
            for (ass in 0...playerOptions[player].length)
            {
                FlxTween.tween(playerOptions[player][ass], {y: choices_y}, 0.18, {ease: FlxEase.quadOut});
            }
        }
        catch (e)
        {
            trace(e.message);
            for (i in 0...playerBoxes.length)
            {
                if (i != 0)
                    deselectChar(i);
                else
                    selectChar(i);
            }
        }
    }

    public function deselectChar(player:Int)
    {
        try
        {
            var time:Float = 0.2;
            var upperOffsetthingy = 75;
            var wherego = (FlxG.height - bottomOutline.height) - upperOffsetthingy;
            FlxTween.tween(playboxOutline[player], {y: wherego - 5, alpha: 0}, time, {ease: FlxEase.quadOut});
            FlxTween.tween(playerBoxes[player], {y: wherego}, time, {ease: FlxEase.quadOut});
            FlxTween.tween(healthSprite[player], {y: wherego + 40}, time - 0.02, {ease: FlxEase.quadOut});
            FlxTween.tween(healthRed[player], {y: wherego + 40}, time - 0.02, {ease: FlxEase.quadOut});
            FlxTween.tween(healthText[player], {y: wherego + 11}, time - 0.02, {ease: FlxEase.quadOut});
            FlxTween.tween(staticHPText[player], {y: wherego + 35}, time - 0.02, {ease: FlxEase.quadOut});
            FlxTween.tween(nameText[player], {y: wherego + 10}, time - 0.02, {ease: FlxEase.quadOut});
            FlxTween.tween(icons[player], {y: wherego}, time - 0.02, {ease: FlxEase.quadOut});
            FlxTween.tween(playboxUnderline[player], {y: wherego + upperOffsetthingy, alpha: 0}, time - 0.02, {ease: FlxEase.quadOut});

            for (ass in 0...playerOptions[player].length)
            {
                FlxTween.tween(playerOptions[player][ass], {y: FlxG.height - bottomOutline.height + 8}, 0.18, {ease: FlxEase.quadOut});
            }
        }
        catch (e)
        {
            trace(e.message);
            for (i in 0...playerBoxes.length)
            {
                if (i != 0)
                    deselectChar(i);
                else
                    selectChar(i);
            }
        }
    }

    public function updateOption(player:Int, option:Int)
    {
        for (i in 0...playerOptions.length)
        {
            for (j in 0...playerOptions[i].length)
            {
                playerOptions[i][j].animation.play('unhover');
            }
        }

        playerOptions[player][option].animation.play('hover');
    }

    public function updateBar(player:Int, damage:Int)
    {
        var currentHealth:Int = DeltaruneState.health[player];
        var limit:Int = DeltaruneState.healthLimit[player];

        healthString[player] = Std.string(currentHealth) + " / " + Std.string(limit);
        healthText[player].text = healthString[player];

        var percent = Math.round(currentHealth / limit * 100);
        healthSprite[player].scale.x = (percent / 100);
        healthSprite[player].updateHitbox();
        healthSprite[player].x = regHealthX[player];
        //healthSprite[player].x = regHealthX[player] - (regHealthWidth * (percent / 100));

        //update health icon?
        if (percent < 20)
			icons[player].animation.curAnim.curFrame = 1;
		else
			icons[player].animation.curAnim.curFrame = 0;
    }

    public function startDefaultDialogue(text:String)
    {
        add(bottomText);
        bottomText.resetText("* " + text);
        bottomText.start(0.02, true);
    }

    public function addMagicText(text:Array<DeltaruneAlphabet>)
    {
        remove(bottomText);

        magicText = text;

        for (i in 0...magicText.length)
        {
            magicText[i].setGroup();
            add(magicText[i].group);
        }
    }

    public function removeMagicText()
    {
        for (i in 0...magicText.length)
        {
            remove(magicText[i].group);
        }

        magicText = [];
    }

    public function confirmOption(player:Int, option:Int)
    {
        
    }

    //DEBUG SHIT LOL
    var SPREEEAD:FlxPoint = new FlxPoint(0, 0);

    public function moveMagicOptions()
    {
        var speed = 5;

        if (FlxG.keys.pressed.SHIFT)
            speed = 10;

        if (FlxG.keys.pressed.CONTROL)
            speed = 1;

        var controls = [FlxG.keys.pressed.LEFT, FlxG.keys.pressed.RIGHT, FlxG.keys.pressed.DOWN, FlxG.keys.pressed.UP];

        for (i in 0...magicText.length)
        {
            if (controls[0])
                magicText[i].updatePosition(new FlxPoint(-speed, 0));
            if (controls[1])
                magicText[i].updatePosition(new FlxPoint(speed, 0));
            if (controls[2])
                magicText[i].updatePosition(new FlxPoint(0, -speed));
            if (controls[3])
                magicText[i].updatePosition(new FlxPoint(0, speed));
        }

        if (controls[0] || controls[1] || controls[2] || controls[3])
        {
            trace('MAGIC POS: ' + magicText[0].x + ' ' + magicText[0].y);
        }

        var spreadControls = [FlxG.keys.pressed.J, FlxG.keys.pressed.L, FlxG.keys.pressed.I, FlxG.keys.pressed.K];

        for (i in 0...magicText.length)
        {
            if (i % 2 == 1) //for every even
            {
                if (spreadControls[0])
                {
                    magicText[i].updatePosition(new FlxPoint(-speed, 0));
                    SPREEEAD.x--;
                }
                if (spreadControls[1])
                {
                    magicText[i].updatePosition(new FlxPoint(speed, 0));
                    SPREEEAD.x++;
                }
            }

            if ((i + 1) % 3 == 0) //for every row thats not one (BUGGY BECAUSE IM DUMM)
            {
                if (spreadControls[2])
                {
                    magicText[i].updatePosition(new FlxPoint(0, -speed));
                    SPREEEAD.y--;
                }

                if (spreadControls[3])
                {
                    magicText[i].updatePosition(new FlxPoint(0, speed));
                    SPREEEAD.y++;
                }
            }
        }

        if (spreadControls[0] || spreadControls[1])
            trace('MAGIC SPREAD: ' + SPREEEAD.x + ' ' + SPREEEAD.y);
    }
}