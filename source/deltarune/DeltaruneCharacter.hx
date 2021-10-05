package deltarune;

class DeltaruneCharacter extends Character
{
    override public function new(x:Int, y:Int, ?char = 'bf', ?isPlayer = false)
    {
        super(x, y, char, isPlayer, 'pablo');
    }

    override function update(elapsed:Float)
    {
        
        super.update(elapsed);
    }

    //DELTAROOON SHIT
	public function adjustDeltaroon(zoom:Float)
	{
		setGraphicSize(Std.int(width * zoom));
		updateHitbox();
	}
}