package entities;
import flixel.text.FlxText;
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

    public var walkChance:Float = 50;
    public var walking = false;
    private var walkTargetX:Float = 0;
    private var walkTime:Float = 0;
    private var maxWalkTime = 10;

    public var fightChance:Float = 15;
    public var fighting = false;
    public var fightTarget:Citizen;
    public var runChance:Float = 10;
    public var punchChance = .15;

    private var taskTimer:FlxTimer;
    public var waiting = false;

    public var killSelf = false;
    private var suicideChance = 10;

    public var name = "No One";
    private var nameText:FlxText;

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
        nameText = new FlxText(this.x, this.y, this.width, this.name);
        nameText.color = this.color;
        state.add(nameText);
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

        nameText.x = this.x + nameText.width/4;
        nameText.y = this.y - nameText.height;

        if (health <= 0) {
            nameText.kill();
            this.clearTasks();
            this.kill();
        }
        if (!waiting) {
            if (walk()) {
                return;
            }

            if (fight()) {
                return;
            }

            if (suicide()){
                return;
            }

            taskTimer.start(FlxRandom.floatRanged(WAIT_TIME_MIN, WAIT_TIME_MAX), getNewTask, 1);
            waiting = true;
            animation.play("waiting");
            //FlxG.log.add(name + " new timer started");
        }
    }

    private function getNewTask(t:FlxTimer):Void {
        if (waiting) {
            waiting = false;
            if (FlxRandom.chanceRoll(walkChance)){
                walking = true;
                walkTargetX = FlxRandom.floatRanged(50, FlxG.width - 50);
                //FlxG.log.add(name + " Starting walk " + walkTargetX);
            } else if (FlxRandom.chanceRoll(fightChance) && state.citizens.countLiving() >= 2) {
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
                    FlxG.log.add(name + " Starting to fight with " + fightTarget.name);
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
        walkTime += FlxG.elapsed;

        if (walkTargetX > this.x ) {
            this.facing = FlxObject.RIGHT;
        } else {
            this.facing = FlxObject.LEFT;
        }

        if (Math.round(this.x) == Math.round(walkTargetX) || walkTime > maxWalkTime) {
            walking = false;
            walkTime = 0;
           // FlxG.log.add(name + " Done Walking");
            return false;
        }

        return true;
    }

    private function suicide():Bool {
        if (!killSelf) {
            return false;
        }

        //FlxG.log.add("Suicide Chance");

        if (FlxRandom.chanceRoll(suicideChance)) {
            health = 0;
            FlxG.log.add(name + " killed themselves!!");
            return true;
        }

        return false;
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

        if (FlxRandom.chanceRoll(punchChance)) {
            fightTarget.health -= FlxRandom.float();
            animation.play("punch");
            FlxG.log.add(name + " Punched! " + fightTarget.name + ". They now have " + fightTarget.health + " health left.");
        }

        if (!fightTarget.alive) {
            fighting = false;
            FlxG.log.add(name + " killed " + fightTarget.name);
            fightTarget = null;
            animation.play("waiting");
            return false;
        }

        if (FlxRandom.chanceRoll(runChance)) {
            FlxG.log.add(name + " ran from " + fightTarget.name);
            fightTarget.clearTasks();
            this.clearTasks();
            animation.play("waiting");
            return false;
        }

        return true;
    }

    public function clearTasks():Void {
        waiting = false;
        walking = false;
        fighting = false;
        fightTarget = null;
    }

    override public function kill():Void {
        clearTasks();
        super.kill();
    }
}
