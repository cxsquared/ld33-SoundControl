package entities;
import flixel.util.FlxPoint;
import flixel.util.FlxVelocity;
import flixel.FlxG;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxColorUtil;
import flixel.FlxSprite;
class Citizen extends FlxSprite {

    public static var CITIZEN_WIDTH = 50;
    public static var CITIZEN_HEIGHT = 100;
    public static var WAIT_TIME_MIN = 0.5;
    public static var WAIT_TIME_MAX = 3;

    private var walking = false;
    private var walkTargetX:Float = 0;

    private var taskTimer:FlxTimer;
    private var waiting = false;

    public function new(X:Float=0, Y:Float=0) {
        super(X, Y);

        makeGraphic(CITIZEN_WIDTH, CITIZEN_HEIGHT, FlxColorUtil.getRandomColor());

        taskTimer = new FlxTimer();
        taskTimer.start(FlxRandom.floatRanged(WAIT_TIME_MIN, WAIT_TIME_MAX), getNewTask, 1);
        waiting = true;

        acceleration.y = 600;
    }

    override public function update():Void {
        super.update();
        if (walk()) {
            return;
        }

        if (!waiting) {
            taskTimer.start(FlxRandom.floatRanged(WAIT_TIME_MIN, WAIT_TIME_MAX), getNewTask, 1);
            waiting = true;
            FlxG.log.add("new timer started");
        }
    }

    private function getNewTask(t:FlxTimer):Void {
        waiting = false;
        walking = true;
        walkTargetX = FlxRandom.floatRanged(0, FlxG.width);
        FlxG.log.add("Starting walk " + walkTargetX);
    }

    private function walk():Bool {
        if (!walking) {
            return false;
        }

        FlxG.log.add("Walking..." + this.x + ":" + walkTargetX);
        FlxVelocity.moveTowardsPoint(this, new FlxPoint(walkTargetX + this.width/2, this.y));

        if (Math.round(this.x) == Math.round(walkTargetX)) {
            walking = false;
            FlxG.log.add("Done Walking");
            return false;
        }

        return true;
    }
}
