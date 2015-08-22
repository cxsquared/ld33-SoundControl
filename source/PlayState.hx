package;

import flixel.util.FlxRandom;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxCollision;
import entities.Citizen;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
    var floor:FlxSprite;
    public var citizens:FlxTypedGroup<Citizen>;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		floor = new FlxSprite(0, FlxG.height - 20);
        floor.makeGraphic(FlxG.width, 20);
        floor.immovable = true;
        add(floor);

        addCitizens();

	}

    private function addCitizens():Void {
        citizens = new FlxTypedGroup<Citizen>();
        for (i in 0...25) {
            var citizen = new Citizen(FlxRandom.floatRanged(0, FlxG.width), 300, this);
            citizens.add(citizen);
        }
        add(citizens);
    }
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

        FlxG.collide(floor, citizens);
	}	
}