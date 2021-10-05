package deltarune;

import flixel.math.FlxPoint;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxSprite;
import flixel.math.FlxRect;
import flixel.FlxG;
import flixel.util.FlxColor;

class DeltaruneHeart extends FlxSprite
{
    public var collisionBox:FlxRect;
    public var ableToMove:Bool = false;

    public var heart_x = 0;
    public var heart_y = 0;

    var isMoving = false;

    var pressed:Array<Bool> = [
        PlayerSettings.player1.controls.LEFT,
        PlayerSettings.player1.controls.RIGHT,
        PlayerSettings.player1.controls.UP,
        PlayerSettings.player1.controls.DOWN
    ];

    var speed:Int = 4;
    var xSpeed:Int = 0;
    var ySpeed:Int = 0;

    override public function new(x:Int, y:Int, path:FlxAtlasFrames = null)
    {
        super(x, y);
        
        frames = path;
        animation.addByIndices('normal', 'Heart', [0], "", 24);
        animation.addByIndices('broke', 'Heart', [1], "", 24);
        animation.play('normal');

        //input moment
        collisionBox = new FlxRect(x, y, frameWidth, frameHeight);

        heart_x = x;
        heart_y = y;
    }

    override public function update(elapsed:Float)
    {
        controlMovement();
        
        x = heart_x;
        y = heart_y;
        collisionBox.x = heart_x;
        collisionBox.y = heart_y;

        super.update(elapsed);
    }

    function checkBoundingBoxes(rects:Array<FlxRect>, key:Int)
    {
        if (rects == [])
            return;

        var nextPoint = new FlxPoint(0, 0);
        var stopWhich = [false, false]; //x or y

        switch (key)
        {
            case 0: //left
            {
                nextPoint = new FlxPoint(collisionBox.left + xSpeed, heart_y);
                stopWhich[0] = true;
            }
            case 1: //right
            {
                nextPoint = new FlxPoint(collisionBox.right + xSpeed, heart_y);
                stopWhich[0] = true;
            }
            case 2: //up
            {
                nextPoint = new FlxPoint(heart_x, collisionBox.top + ySpeed);
                stopWhich[1] = true;
            }
            case 3: //down
            {
                nextPoint = new FlxPoint(heart_x, collisionBox.bottom + ySpeed);
                stopWhich[1] = true;
            }
        }

        if (rects[key].containsPoint(nextPoint))
        {
            if (stopWhich[0])
                xSpeed = 0;

            if (stopWhich[1])
                ySpeed = 0;
        }
    }

    function controlMovement() //movement moment
    {
        if (ableToMove)
        {
            pressed = [
                PlayerSettings.player1.controls.LEFT,
                PlayerSettings.player1.controls.RIGHT,
                PlayerSettings.player1.controls.UP,
                PlayerSettings.player1.controls.DOWN
            ];

            if (pressed[0] || pressed[1] || pressed[2] || pressed[3])
            {
                if (pressed[0])
                {
                    xSpeed = -speed;
                    checkBoundingBoxes(DeltaruneState.outlineRects, 0);
                    heart_x += xSpeed;
                }
                if (pressed[1])
                {
                    xSpeed = speed;
                    checkBoundingBoxes(DeltaruneState.outlineRects, 1);
                    heart_x += xSpeed;
                }
                if (pressed[2])
                {
                    ySpeed = -speed;
                    checkBoundingBoxes(DeltaruneState.outlineRects, 2);
                    heart_y += ySpeed;
                }
                if (pressed[3])
                {
                    ySpeed = speed;
                    checkBoundingBoxes(DeltaruneState.outlineRects, 3);
                    heart_y += ySpeed;
                }

                isMoving = true;
            }
            else 
            {
                isMoving = false;
            }
        }
    }
}