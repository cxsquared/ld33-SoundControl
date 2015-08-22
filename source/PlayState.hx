package;

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
    var citizen:Citizen;

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

        citizen = new Citizen(FlxG.width/2, 300);
        add(citizen);
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

        FlxG.collide(floor, citizen);
	}	
}