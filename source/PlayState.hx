package;

import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import managers.CitizenManager;
import managers.SoundManager;
import managers.UIController;
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
    var bounds:FlxTypedGroup<FlxSprite>;
    public var citizens:CitizenManager;
    var ui:UIController;
    //public var soundManager = new SoundManager();
    private var citizenTimer = new FlxTimer();
    public var disco = new FlxSprite();

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

        SoundManager.init();

        var background = new FlxSprite(0,0);
        background.loadGraphic(AssetPaths.background__png);
        add(background);

        citizens = new CitizenManager(this);

        ui = new UIController(this, FlxG.height/3*2);
        add(ui);

        setUpBounds();

        addCitizens();
        citizens.callAll("addHair");

        citizenTimer.start(FlxRandom.floatRanged(30, 120), moreCitizens, 1);

        disco.loadGraphic(AssetPaths.disco__png);
        disco.visible = false;
        add(disco);

	}

    private function setUpBounds():Void {
        bounds = new FlxTypedGroup<FlxSprite>();
        var floor = new FlxSprite(0, FlxG.height/3*2);
        floor.makeGraphic(FlxG.width, 20, FlxColor.TRANSPARENT);
        floor.immovable = true;
        bounds.add(floor);

        var wall = new FlxSprite(0, 0);
        wall.makeGraphic(20, Std.int(FlxG.height/3*2), FlxColor.TRANSPARENT);
        wall.x -= wall.width/2;
        wall.immovable = true;
        bounds.add(wall);

        var wall = new FlxSprite(FlxG.width, 0);
        wall.makeGraphic(20, Std.int(FlxG.height/3*2), FlxColor.TRANSPARENT);
        wall.x -= wall.width/2;
        wall.immovable = true;
        bounds.add(wall);

        add(bounds);
    }

    private function moreCitizens(t:FlxTimer):Void {
        citizens.addCitizens(FlxRandom.intRanged(1, 3));
        citizenTimer.start(FlxRandom.floatRanged(30, 120), moreCitizens, 1);
    }

    private function addCitizens():Void {
        citizens.addCitizens(5);
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
        SoundManager.update();

        FlxG.collide(bounds, citizens);

        if (SoundManager.soundLevels.Metal >= 1 && SoundManager.soundLevels.Dance >= 1 && SoundManager.soundLevels.Noise >= 1 && SoundManager.soundLevels.Chill <= 0) {
            disco.visible = true;
        } else {
            disco.visible = false;
        }
	}
}