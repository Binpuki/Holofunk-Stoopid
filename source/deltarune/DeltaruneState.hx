package deltarune;

import flixel.FlxBasic;
import openfl.Lib;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxRect;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxColor;

class DeltaruneState extends MusicBeatState
{
    //background
    var lol:FlxSprite;

    //Player characters
    public static var playerIndex:Array<String> = ['bf', 'bf_aloe-deltarune', 'bf_aloe-deltarune'];
    var playerChars:Array<DeltaruneCharacter> = [];
    var playerSpread:Int = 315; //How far the characters should be spread apart on the y-axis
    
    public static var initialLocations:Array<FlxPoint> = [new FlxPoint(0, 0), new FlxPoint(0, 0), new FlxPoint(0, 0)];

    public static var playerNames:Array<String> = ['BF', 'ALOE', 'GOD'];
    public static var playerColors:Array<FlxColor> = [FlxColor.fromRGB(49, 176, 209), FlxColor.fromRGB(239, 113, 177), FlxColor.fromRGB(49, 176, 209)];

    var heart:DeltaruneHeart;
    public static var boundingBox:FlxRect;
    public static var boundOutlines:Array<FlxSprite> = [];
    public static var outlineRects:Array<FlxRect> = [];

    //choices
    //FIGHT, ACT, ITEM, SPARE, DEFEND, MAGIC
    //DEBUGGING STUFF: ASS, DOMINATE
    public static var choices:Array<Array<String>> = [
        ['FIGHT', 'ACT', 'ITEM', 'SPARE', 'DEFEND'], 
        ['FIGHT', 'MAGIC', 'ITEM', 'SPARE', 'DEFEND'], 
        ['ALOENIUM', 'ASS', 'ITEM', 'SPARE', 'DEFEND']
    ];

    public static var bottomText:Array<String> = [
        'You are stuck in a black room.',
        'Something something bla bla bla',
        'Cool'
    ];

    public static var health:Array<Int> = [100, 100];
    public static var healthLimit:Array<Int> = [100, 100];

    public static var selectedPlayer:Int = 0;
    public static var selectedOption:Int = 0;

    var debugMode:Bool = false;

    //GUI shit
    var camBG:FlxCamera;
    var camChars:FlxCamera;
    var camDanmaku:FlxCamera;
    var camHUD:FlxCamera;

    public static var camPoint:FlxPoint = new FlxPoint(FlxG.width / 2, FlxG.height / 2); //CHANGE THIS WHEN YOU WANT A COOL TRANSITION INTO BATTLE
    var camFollow:FlxObject;
    public static var camZoom:Float = 1;

    public static var initialCharZoom:Float = 0.9;
    public static var charZoom:Float = 0.4;

    var transitionDuration:Float = 1;

    public static var oldStage = 'stage';
    var stageHandler:StageHandler;
    var oldBackgroundShit:FlxTypedGroup<FlxSprite>;

    //FOR DEBUG, TESTING THE FONT LOL
    var fontTest:FlxText;
    var fontTestFont:String = 'Pixel Arial 11 Bold';

    var menuShit:DeltaruneMenu;

    override public function create():Void
    {
        camFollow = new FlxObject(Std.int(camPoint.x), Std.int(camPoint.y));

        camBG = new FlxCamera();
        camChars = new FlxCamera();
        camDanmaku = new FlxCamera();
        camHUD = new FlxCamera();

        camChars.bgColor.alpha = 0;
        camDanmaku.bgColor.alpha = 0;
        camHUD.bgColor.alpha = 0;

        camChars.zoom = initialCharZoom;
        camChars.target = camFollow;

        camBG.zoom = initialCharZoom;
        camBG.target = camFollow;
        trace(camChars.x + ' ' + camChars.y);

        FlxTween.tween(camChars, {zoom: charZoom}, transitionDuration);

        //Make old stage shit
        stageHandler = new StageHandler(oldStage);
        oldBackgroundShit = stageHandler.sprites;
        
        oldBackgroundShit.forEach(function(sprite:FlxSprite){
            sprite.cameras = [camBG];
            add(sprite);
            FlxTween.tween(sprite, {alpha: 0}, transitionDuration);
        });
        
        //camFollow = new FlxObject(0, 0, 1, 1);
		//camFollow.setPosition(camPoint.x, camPoint.y);

        FlxG.cameras.reset(camBG);
        FlxG.cameras.add(camChars, false);
        FlxG.cameras.add(camDanmaku, true);
        FlxG.cameras.add(camHUD, false);

        FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

        //FlxG.cameras.setDefaultDrawTarget(camGame, true);

        //add(camFollow);

        //FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		//FlxG.camera.zoom = camZoom;
		//FlxG.camera.focusOn(camFollow.getPosition());

        lol = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.PURPLE);
        lol.cameras = [camBG];
        //add(lol);

        var origin = new FlxPoint(camPoint.x + (1630 - (FlxG.width / 2)), camPoint.y);

        for (i in 0...playerIndex.length)
        {
            var playerPoint:FlxPoint;
            switch (playerIndex.length)
            {
                case 3:
                    playerPoint = new FlxPoint(origin.x, origin.y + (-440 - (FlxG.height / 3)));
                case 2:
                    playerPoint = new FlxPoint(origin.x, origin.y + (-172 - (FlxG.height)));
                default:
                    playerPoint = new FlxPoint(origin.x, origin.y + (-63 - (FlxG.height)));
            }

            trace(playerPoint);

            playerChars[i] = new DeltaruneCharacter(Std.int(initialLocations[i].x), Std.int(initialLocations[i].y), playerIndex[i], true);

            trace(new FlxPoint(playerChars[i].x, playerChars[i].y));

            FlxTween.tween(playerChars[i], {x: playerPoint.x, y: playerPoint.y + (playerSpread * i)}, transitionDuration);
            
            playerChars[i].cameras = [camChars];
            add(playerChars[i]);
            //playerChars[i].adjustDeltaroon(ZOOMIE);
        }

        menuShit = new DeltaruneMenu(playerIndex.length);
        menuShit.choices = choices;
        menuShit.ui.cameras = [camHUD];

        heart = new DeltaruneHeart(200, 50, Paths.getSparrowAtlas('deltarune/Heart', 'pablo'));
        heart.cameras = [camDanmaku];
        add(heart);

        //WHEN THE BATTLE STARTS LOL
        new FlxTimer().start(transitionDuration, function(tmr:FlxTimer)
        {
            oldBackgroundShit.destroy();
            startBattle();
        });

        //Make the box
        var boxSize = 300;
        var freeSpace = (FlxG.height) - (menuShit.ui.bottomOutline.height);
        var boxOutlineSize = 5;

        boundingBox = new FlxRect((FlxG.width / 2) - (boxSize / 2), (freeSpace / 2) - (boxSize / 2), boxSize, boxSize);
       
        heart.heart_x = Std.int(boundingBox.x + (boundingBox.width / 2) - (heart.frameWidth / 2));
        heart.heart_y = Std.int(boundingBox.y + (boundingBox.height / 2) - (heart.frameHeight / 2));

        //left
        boundOutlines[0] = new FlxSprite(boundingBox.left - boxOutlineSize, boundingBox.y).makeGraphic(boxOutlineSize, Std.int(boundingBox.height), FlxColor.WHITE);
        outlineRects[0] = new FlxRect(boundOutlines[0].x, boundOutlines[0].y, boundOutlines[0].width, boundOutlines[0].height);
        //right
        boundOutlines[1] = new FlxSprite(boundingBox.right, boundingBox.y).makeGraphic(boxOutlineSize, Std.int(boundingBox.height), FlxColor.WHITE);
        outlineRects[1] = new FlxRect(boundOutlines[1].x, boundOutlines[1].y, boundOutlines[1].width, boundOutlines[1].height);
        //up
        boundOutlines[2] = new FlxSprite(boundOutlines[0].x, boundingBox.top - boxOutlineSize).makeGraphic(Std.int(boundingBox.width + (boxOutlineSize * 2)), boxOutlineSize);
        outlineRects[2] = new FlxRect(boundOutlines[2].x, boundOutlines[2].y, boundOutlines[2].width, boundOutlines[2].height);
        //down
        boundOutlines[3] = new FlxSprite(boundOutlines[0].x, boundingBox.bottom).makeGraphic(Std.int(boundingBox.width + (boxOutlineSize * 2)), boxOutlineSize);
        outlineRects[3] = new FlxRect(boundOutlines[3].x, boundOutlines[3].y, boundOutlines[3].width, boundOutlines[3].height);

        for (i in 0...boundOutlines.length)
        {
            boundOutlines[i].cameras = [camDanmaku];
            add(boundOutlines[i]);
        }

        trace(heart.cameras);

        add(menuShit.ui);

        super.create();
    }

    var oldKeys:Array<Bool> = [false, false, false];
    var adjustMagicShit = false;

    override function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ONE)
        {
            debugMode = !debugMode;
        }

        if (FlxG.keys.justPressed.TWO)
        {
            menuShit.playerControl = !menuShit.playerControl;

            adjustMagicShit = !adjustMagicShit;
        }

        if (adjustMagicShit)
        {
            menuShit.ui.moveMagicOptions();
        }

        if (PlayerSettings.player1.controls.LEFT_P)
        {
            menuShit.handleMenuShit(Std.string(-1));
        }

        if (PlayerSettings.player1.controls.RIGHT_P)
        {
            menuShit.handleMenuShit(Std.string(1));
        }

        if (PlayerSettings.player1.controls.ACCEPT || FlxG.keys.justPressed.Z)
        {
            menuShit.handleMenuShit('enter');
        }

        if (PlayerSettings.player1.controls.BACK || FlxG.keys.justPressed.X)
        {
            menuShit.goBack();
        }

        debugModeShit();

        super.update(elapsed);
    }

    override function beatHit()
    {
        for (i in 0...playerChars.length)
        {
            playerChars[i].dance();
        }

        //fucking bullshit
        //trace("PLAYER BOX POS: " + playerBoxes[0].x + " " + playerBoxes[0].y + "\nOUTLINE POS: " + playboxOutline[0].x + " " + playboxOutline[0].y);

        super.beatHit();
    }

    function handleControls()
    {

    }

    function takeDamage(player:Int, damage:Int)
    {
        health[player] -= damage;

        menuShit.ui.updateBar(player, damage);
    }

    function startBattle()
    {
        menuShit.ui.showUI();

        //FlxTween.tween(camGame, {zoom: 0.3}, 1);
        //FlxTween.tween(camChars, {zoom: 0.3}, 1);

        new FlxTimer().start(1, function(tmr:FlxTimer){
            menuShit.ui.selectChar(0);
            menuShit.playerControl = true;
        });
    }

    function debugModeShit()
    {
        if (debugMode)
        {
            if (FlxG.keys.justPressed.ESCAPE)
            {
                FlxG.switchState(new MainMenuState());
            }

            if (FlxG.keys.justPressed.Q)
            {
                menuShit.ui.deselectChar(selectedPlayer);
                menuShit.ui.selectChar(0);
                selectedPlayer = 0;
            }

            if (FlxG.keys.justPressed.W)
            {
                menuShit.ui.deselectChar(selectedPlayer);
                menuShit.ui.selectChar(1);
                selectedPlayer = 1;
            }

            if (FlxG.keys.justPressed.E)
            {
                menuShit.ui.deselectChar(selectedPlayer);
                menuShit.ui.selectChar(2);
                selectedPlayer = 2;
            }

            if (FlxG.keys.justPressed.ENTER)
            {
                playerChars[selectedPlayer].playAnim('idle', true);
            }

            if (FlxG.keys.justPressed.O)
            {
                var thingy:Int = FlxG.random.int(0, bottomText.length - 1);
                heart.ableToMove = !heart.ableToMove;

                if (heart.ableToMove)
                {
                    menuShit.ui.deselectChar(selectedPlayer);
                    menuShit.ui.hideUI();
                }
                else
                {
                    selectedPlayer = 0;
                    selectedOption = 0;
                    menuShit.ui.showUI([selectedPlayer]);
                    menuShit.ui.selectChar(selectedPlayer);
                }

                menuShit.ui.startDefaultDialogue(bottomText[thingy]);
            }

            //debug characters
            for (i in 0...playerChars.length)
            {
                var forCharPressed = [
                    FlxG.keys.pressed.J, 
                    FlxG.keys.pressed.L, 
                    FlxG.keys.pressed.I, 
                    FlxG.keys.pressed.K, 
                    FlxG.keys.pressed.N, 
                    FlxG.keys.pressed.M, 
                    FlxG.keys.pressed.V, 
                    FlxG.keys.pressed.B,
                    FlxG.keys.pressed.T,
                    FlxG.keys.pressed.G,
                    FlxG.keys.pressed.F,
                    FlxG.keys.pressed.H
                ];

                var speed = 5;

                if (FlxG.keys.pressed.SHIFT)
                    speed = 10;

                if (FlxG.keys.pressed.CONTROL)
                    speed = 1;

                //MOVING POSITION OF PLAYERS
                if (forCharPressed[0])
                    playerChars[i].x -= speed;

                if (forCharPressed[1])
                    playerChars[i].x += speed;

                if (forCharPressed[2])
                    playerChars[i].y -= speed;

                if (forCharPressed[3])
                    playerChars[i].y += speed;

                if (forCharPressed[0] || forCharPressed[1] || forCharPressed[2] || forCharPressed[3])
                    trace('PLAYER 1 POSITION: ' + playerChars[0].x + ' ' + playerChars[0].y);

                //SPREADING PLAYERS
                if (forCharPressed[4])
                    playerSpread += speed;

                if (forCharPressed[5])
                    playerSpread -= speed;

                if (forCharPressed[4] || forCharPressed[5])
                    trace('PLAYER SPREAD: ' + playerSpread);

                //CAM ZOOM SHIT
                if (forCharPressed[6])
                    camChars.zoom -= (speed / 1000);

                if (forCharPressed[7])
                    camChars.zoom += (speed / 1000);

                if (forCharPressed[6] || forCharPressed[7])
                    trace('CHARACTER ZOOM: ' + camChars.zoom);

                if (forCharPressed[8])
                    camFollow.y -= speed;
                
                if (forCharPressed[9])
                    camFollow.y += speed;

                if (forCharPressed[10])
                    camFollow.x -= speed;

                if (forCharPressed[11])
                    camFollow.x += speed;
            }
        }
    }
}

class DeltaruneMenu
{
    public var choices:Array<Array<String>> = [];

    public var enemyIDs:Array<Int> = [];
    public var enemyNames:Array<Int> = [];
    
    public var magicShit:Array<Array<Int>> = []; //THESE ALSO SERVE AS ACT FOR KRIS / BF / WHATEVER
    public var magicNames:Array<Array<Int>> = [];

    public var itemIDs:Array<Int> = [];
    public var itemNames:Array<Int> = [];

    public var playerControl = false;

    var selectedPlayer = 0;

    var prevSelect:Array<Int> = [];
    var prevMenu:Array<String> = [];

    var mainOption:Int = 0;
    var option:Int = 0;
    var submenu:String = 'main';

    var amtOfPlayers:Int;

    public var ui:DeltaruneUI;

    public function new(amtOfPlayers:Int)
    {
        this.amtOfPlayers = amtOfPlayers;

        ui = new DeltaruneUI(amtOfPlayers);
    }

    public function changePlayer(player:Int)
    {
        selectedPlayer = player;
        option = 0;

        ui.updateOption(player, option);
    }

    public function handleMenuShit(change:String)
    {
        if (playerControl)
        {
            switch (submenu)
            {
                case 'main':
                    mainButtons(change);

                case 'MAGIC' | 'ACT':
                    magicOptions(change);

                default:
                    trace('bro ' + submenu + ' dont exist bro');
                    submenu = 'main';
                    handleMenuShit('0');
            }
        }
    }

    public function goBack()
    {
        if (playerControl)
        {
            switch (submenu)
            {
                case 'main':
                {
                    if ((selectedPlayer - 1) >= 0)
                    {
                        selectedPlayer -= 1;
                        
                        for (i in 0...amtOfPlayers)
                        {
                            if (i != selectedPlayer)
                                ui.deselectChar(i);
                            else
                                ui.selectChar(i);
                        }

                        submenu = prevMenu[selectedPlayer];

                        handleMenuShit(Std.string(mainOption));
                    }
                    else
                    {
                        trace('bitch u cant go back lol');
                    }
                }

                case 'MAGIC' | 'ACT':
                {
                    ui.removeMagicText();
                    submenu = 'main';
                    handleMenuShit(Std.string(prevSelect));
                }
            }
        }
    }

    function mainButtons(change:String)
    {
        if (change != 'enter')
        {
            var changeThingy = Std.parseInt(change);

            option += changeThingy;

            //Checks
            try
            {
                if (option > choices[selectedPlayer].length - 1)
                {
                    option = 0;
                }
                if (option < 0)
                {
                    option = choices[selectedPlayer].length - 1;
                }
            }
            catch (e)
            {
                trace(e);
            }

            ui.updateOption(selectedPlayer, option);
        }
        else
        {
            submenu = choices[selectedPlayer][option];

            mainOption = option;
            prevSelect[selectedPlayer] = mainOption;

            //initiate shit
            switch (submenu)
            {
                case 'MAGIC' | 'ACT':
                    initiateMagic();
                    option = 0;
                case 'main':
                    ui.removeMagicText();
                    ui.startDefaultDialogue('lol');
            }

            handleMenuShit('0');
        }
    }

    var placeholderIDs:Array<Int> = [
        
    ];

    var placeholderShit:Array<Array<String>> = [
        [
            'icon:bf_nene',
            'text:Roll'
        ],
        [
            'text:poop'
        ],
        [
            'icon:bf_nene',
            'text:poop together'
        ],
        [
            'text:fourth option'
        ],
        [
            'text:Bottom Text'
        ],
        [
            'icon:bf_nene',
            'text:have sex'
        ]
    ];

    function initiateMagic()
    {
        var thing = placeholderShit;

        var poop = new Array<DeltaruneAlphabet>();

        var offset:FlxPoint = new FlxPoint(18, 570);
        
        var addY = 0;
        var yThingy = 35;
        
        for (i in 0...thing.length)
        {
            var addEven = 550;
            var ifEven = false;

            var addX = 0;
            
            if ((i) % 2 == 1)
            {
                ifEven = true;
                addX = addEven;
            }

            poop[i] = new DeltaruneAlphabet(Std.int(offset.x + addX), Std.int(offset.y + addY));
            poop[i].setText(thing[i]);

            trace('iofugijrfe: ' + (offset.x + addX));
            trace(poop[i].x);

            if (ifEven)
                addY += yThingy;
        }

        ui.addMagicText(poop);
    }

    function magicOptions(change:String)
    {
        var convertChange = Std.parseInt(change);

        //prevMenu[selectedPlayer] = submenu; put this somewhere
    }
}