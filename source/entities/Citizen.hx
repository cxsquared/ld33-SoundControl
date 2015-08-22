package entities;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.util.FlxMath;
import flixel.util.FlxMath;
import flixel.FlxState;
import flixel.util.FlxPoint;
import flixel.util.FlxVelocity;
import flixel.FlxG;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxColorUtil;
import flixel.FlxSprite;
class Citizen extends FlxSprite {

    public static var CITIZEN_WIDTH = 75;
    public static var CITIZEN_HEIGHT = 100;
    public static var WAIT_TIME_MIN = 0.5;
    public static var WAIT_TIME_MAX = 3;

    public var walking = false;
    private var walkTargetX:Float = 0;

    public var fighting = false;
    public var fightTarget:Citizen;

    private var taskTimer:FlxTimer;
    public var waiting = false;

    public var name = "No One";

    private var state:PlayState;

    public function new(X:Float=0, Y:Float=0, State:PlayState=null) {
        super(X, Y);

        this.state = State;

        createAnimations();
       // makeGraphic(CITIZEN_WIDTH, CITIZEN_HEIGHT, FlxColorUtil.getRandomColor());

        taskTimer = new FlxTimer();
        taskTimer.start(FlxRandom.floatRanged(WAIT_TIME_MIN, WAIT_TIME_MAX), getNewTask, 1);
        waiting = true;

        acceleration.y = 600;

        name = Names.getName();
    }

    private function createAnimations():Void {
        loadGraphic(AssetPaths.citizen__png, true, CITIZEN_WIDTH, CITIZEN_HEIGHT);
        setFacingFlip(FlxObject.LEFT, true, false);
        setFacingFlip(FlxObject.RIGHT, false, false);
        this.color = FlxColorUtil.getRandomColor();
        //this.scale.y = FlxRandom.floatRanged(0.9, 1.1);
        animation.add("waiting", [0], 0, false);
        animation.add("walking", [1,2,3,4,5,6], 12, true);
        animation.add("fighting", [7, 8, 7], 6, true);
        animation.add("punch", [9, 7], 6, false);
        animation.play("waiting");
    }

    override public function update():Void {
        super.update();

        if (health <= 0) {
            this.kill();
        }

        if (walk()) {
            return;
        }

        if (fight()) {
            return;
        }

        if (!waiting) {
            taskTimer.start(FlxRandom.floatRanged(WAIT_TIME_MIN, WAIT_TIME_MAX), getNewTask, 1);
            waiting = true;
            animation.play("waiting");
            //FlxG.log.add(name + " new timer started");
        }
    }

    private function getNewTask(t:FlxTimer):Void {
        if (waiting) {
            waiting = false;
            var rand:Float = FlxRandom.float();
            if (rand >= 0.5){
                walking = true;
                walkTargetX = FlxRandom.floatRanged(0, FlxG.width);
                //FlxG.log.add(name + " Starting walk " + walkTargetX);
            } else if (rand >= 0.35 && state.citizens.countLiving() >= 2) {
                //FlxG.log.add(name + " Trying to fight");
                fighting = true;
                var tries = 0;
                while((fightTarget == null || fightTarget == this || !fightTarget.alive) &&  tries < 5) {
                    fightTarget = state.citizens.getRandom();
                    tries++;
                }
                if (tries < 5 && fightTarget.alive && fightTarget != null && fightTarget != this){
                    fightTarget.clearTasks();
                    fightTarget.fighting = true;
                    fightTarget.fightTarget = this;
                    //FlxG.log.add(name + " Starting to fight");
                }
            }
        }
    }

    private function walk():Bool {
        if (!walking) {
            return false;
        }

        //FlxG.log.add("Walking..." + this.x + ":" + walkTargetX);
        FlxVelocity.moveTowardsPoint(this, new FlxPoint(walkTargetX + this.width/2, this.y));
        animation.play("walking");

        if (walkTargetX > this.x ) {
            this.facing = FlxObject.RIGHT;
        } else {
            this.facing = FlxObject.LEFT;
        }

        if (Math.round(this.x) == Math.round(walkTargetX)) {
            walking = false;
           // FlxG.log.add(name + " Done Walking");
            return false;
        }

        return true;
    }

    private function fight():Bool {
        if (!fighting) {
            return false;
        }

        if (Math.abs(FlxMath.distanceBetween(this, fightTarget)) > this.width) {
            FlxVelocity.moveTowardsPoint(this, new FlxPoint(fightTarget.x + this.width/2, this.y));
            if (fightTarget.x > this.x) {
                facing = FlxObject.RIGHT;
            } else {
                facing = FlxObject.LEFT;
            }
            animation.play("walking");
            return true;
        }

        animation.play("fighting");

        if (FlxRandom.chanceRoll(.15)) {
            fightTarget.health -= FlxRandom.float();
            animation.play("punch");
            FlxG.log.add(name + " Punched! " + fightTarget.name + ". They now have " + fightTarget.health + " health left.");
        }

        if (!fightTarget.alive) {
            fighting = false;
            FlxG.log.add(name + " killed " + fightTarget.name);
            fightTarget = null;
            return false;
        }

        return true;
    }

    public function clearTasks():Void {
        waiting = false;
        walking = false;
        fighting = false;
    }

    override public function kill():Void {
        clearTasks();
        super.kill();
    }
}
