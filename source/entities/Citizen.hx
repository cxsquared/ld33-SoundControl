package entities;
import managers.UIController;
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

    //State
    public var angerStat:Float = 0;
    public var danceStat:Float = 100;
    public var exersiceStat:Float = 100;
    public var sleepStat:Float = 100;
    private var statDecreaseChance = 2.5;

    //Walk
    public var walkChance:Float = 50;
    public var walking = false;
    private var walkTargetX:Float = 0;
    private var walkTime:Float = 0;
    private var maxWalkTime = 10;

    //Fight
    public var fightChance:Float = 15;
    public var fighting = false;
    public var fightTarget:Citizen;
    public var runChance:Float = 10;
    public var punchChance = .15;

    //Wait
    private var taskTimer:FlxTimer;
    public var waiting = false;

    //Suicide
    public var killSelf = false;
    private var suicideChance = 10;
    private var dying = false;

    //Dance
    public var dancing = false;
    public var danceChance:Float = 22;
    public var danceDeathChance = .1;
    private var danceTime:Float = 0;
    private var maxDanceTime = 10;
    public var danceQuitChance = .5;

    //Rave
    public var raving = false;
    public var raveChance:Float = 0;

    // Slam
    public var slamming = false;
    public var slamChance:Float = 5;

    // Zombie
    public var zombieing = false;
    public var zombieChance = 2.5;
    private var zombieTarget:Citizen = null;
    private var zombieTime:Float = 0;
    private var maxZombieTime = 15;

    // workout
    public var workingout = false;
    public var workoutChance:Float = 18;
    public var workoutDeathChance = .15;
    public var workoutTime:Float = 0;
    public var maxWorkoutTime = 20;
    public var workoutQuitChance = .5;

    // Sleep
    public var sleeping = false;
    public var sleepChance:Float = 20;
    public var sleepTime:Float = 0;
    public var maxSleepTime = 30;
    public var wakeUpChance = .6;

    public var name = "No One";
    private var nameText:FlxText;

    private var state:PlayState;

    private var hair:FlxSprite;

    public function new(X:Float=0, Y:Float=0, State:PlayState=null) {
        super(X, Y);

        this.state = State;

        createAnimations();
       // makeGraphic(CITIZEN_WIDTH, CITIZEN_HEIGHT, FlxColorUtil.getRandomColor());

        taskTimer = new FlxTimer();
        taskTimer.start(FlxRandom.floatRanged(WAIT_TIME_MIN, WAIT_TIME_MAX), getNewTask, 1);
        waiting = true;

        acceleration.y = 600;

        addName();
    }

    public function addHair():Void {
        /*
        hair = new FlxSprite(this.x, this.y);
        hair.loadGraphic(AssetPaths.hair__png, true, CITIZEN_WIDTH, 30);
        hair.animation.add("0", [0], 0, false);
        hair.animation.add("1", [1], 0, false);
        hair.animation.add("2", [2], 0, false);
        hair.animation.add("3", [3], 0, false);
        hair.animation.add("4", [4], 0, false);
        hair.animation.add("5", [5], 0, false);
        hair.animation.play(Std.string(FlxRandom.intRanged(0, 5)));
        hair.color = FlxColorUtil.getRandomColor();
        //state.add(hair);

        hair.setFacingFlip(FlxObject.LEFT, true, false);
        hair.setFacingFlip(FlxObject.RIGHT, false, false);
        */
    }

    private function addName():Void {
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
        animation.add("walking", [1,2,3,4], 6, true);
        animation.add("fighting", [6, 7, 6], 6, true);
        animation.add("punch", [8, 8, 8, 8, 8, 6], 6, false);
        animation.add("dance", [9, 10, 11, 12, 11], 6, true);
        animation.add("death", [12, 13, 14, 15, 16], 6, false);
        animation.add("sleep", [17, 18, 19, 18, 19, 18], 3, true);
        animation.add("workout", [20, 21, 22, 23, 22, 21], 6, true);
        animation.add("rave", [20, 24, 25, 26, 25, 24, 25, 26, 24, 25], 6, true);
        animation.add("zombie", [27, 28], 3, true);
        animation.add("slam", [10, 29, 30, 29, 31, 29, 11, 29], 6, true);
        animation.play("waiting");

        animation.callback = animCallback;
    }

    override public function update():Void {
        super.update();

        updateStats();

        nameText.x = this.x + nameText.width/4;
        nameText.y = this.y - nameText.height;

        //hair.x = this.x;
        //hair.y = this.y;
        //hair.facing = this.facing;

        if (health <= 0 && !dying) {
            dying = true;
            this.kill();
        }
        if (!waiting && !dying) {
            if (walk()) {
                return;
            }

            if (fight()) {
                return;
            }

            if (chat()) {
                return;
            }

            if (dance()) {
                return;
            }

            if (sleep()) {
                return;
            }

            if (workout()) {
                return;
            }

            if (slam()) {
                return;
            }

            if (zombie()) {
                return;
            }

            if (rave()) {
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

    private function updateStats():Void {

        if (FlxRandom.chanceRoll(statDecreaseChance)){
            var decrease = FlxRandom.intRanged(0, 3);
            //FlxG.log.add(name + " stat decrease");
            switch (decrease) {
                case 0:
                    angerStat += FlxRandom.floatRanged(0.5, 3);
                case 1:
                    danceStat -= FlxRandom.floatRanged(0.5, 3);
                case 2:
                    sleepStat -= FlxRandom.floatRanged(0.5, 3);
                case 3:
                    exersiceStat -= FlxRandom.floatRanged(0.5, 3);
            }
        }

        var badStats = 0;
        if (angerStat > 90) {
            badStats++;
        }
        if (danceStat < 10) {
            badStats++;
        }
        if (sleepStat < 15) {
            badStats++;
        }
        if (exersiceStat < 5) {
            badStats++;
        }

        if (badStats >= 3 && FlxRandom.chanceRoll(statDecreaseChance)) {
            health -= FlxRandom.floatRanged(0.05, 0.25);
            FlxG.log.add(name + " has bad stats " + health);
            if (health <= 0) {
                UIController.updateDeathText("You've let " + name + " die!");
            }
        }
    }

    private function getNewTask(t:FlxTimer):Void {
        if (waiting && !dying) {
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
            } else if (FlxRandom.chanceRoll(danceChance)) {
                danceTime = 0;
                dancing = true;
            } else if (FlxRandom.chanceRoll(workoutChance)) {
                workoutTime = 0;
                workingout = true;
            } else if (FlxRandom.chanceRoll(sleepChance)) {
                sleepTime = 0;
                sleeping = true;
            } else if (FlxRandom.chanceRoll(raveChance)) {
                raving = true;
                danceTime = 0;
            } else if (FlxRandom.chanceRoll(slamChance)) {
                slamming = true;
                danceTime = 0;
            } else if (FlxRandom.chanceRoll(zombieChance)) {
                zombieing = true;
                zombieTime = 0;
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
            UIController.updateDeathText(name + " has killed themselves!!!");
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

        if (FlxRandom.chanceRoll(statDecreaseChance)) {
            angerStat -= FlxRandom.floatRanged(3, 8);
            if (angerStat < 0) {
                angerStat = 0;
            }
        }

        animation.play("fighting");

        if (FlxRandom.chanceRoll(punchChance)) {
            fightTarget.health -= FlxRandom.float();
            animation.play("punch");
            var blood = new Blood(fightTarget.x + fightTarget.width/2, fightTarget.y + fightTarget.height/4, facing);
            state.blood.add(blood);
            FlxG.log.add(name + " Punched! " + fightTarget.name + ". They now have " + fightTarget.health + " health left.");
        }

        if (!fightTarget.alive) {
            fighting = false;
            FlxG.log.add(name + " killed " + fightTarget.name);
            UIController.updateDeathText(fightTarget.name + " was punched to death by " + name);
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

    private function chat():Bool {
        return false;
    }

    private function dance():Bool {
        if (!dancing) {
            return false;
        }

        animation.play("dance");
        danceTime += FlxG.elapsed;
        if (FlxRandom.chanceRoll(statDecreaseChance)){
            danceStat += FlxRandom.floatRanged(3, 8);
            if (danceStat > 100) {
                danceStat = 100;
            }
        }

        if (FlxRandom.chanceRoll(1)) {
            if (facing == FlxObject.RIGHT){
                facing = FlxObject.LEFT;
            } else {
                facing = FlxObject.RIGHT;
            }
        }

        if (danceTime > maxDanceTime/4*3 && FlxRandom.chanceRoll(danceDeathChance)) {
            this.health = 0;
            dancing = false;
            FlxG.log.add(name + " has Danced to death.");
            UIController.updateDeathText(name + " has danced themselves to death.");
            return false;
        }

        if (danceTime > maxDanceTime) {
            dancing = false;
            danceTime = 0;
            return false;
        }

        return true;
    }

    private function workout():Bool {
        if (!workingout){
            return false;
        }

        animation.play("workout");
        workoutTime += FlxG.elapsed;

        if (FlxRandom.chanceRoll(statDecreaseChance)) {
            exersiceStat += FlxRandom.floatRanged(3, 8);
            if (exersiceStat > 100) {
                exersiceStat = 100;
            }
        }

        if (workoutTime > maxWorkoutTime*.85 && FlxRandom.chanceRoll(workoutDeathChance)) {
            this.health = 0;
            workingout = false;
            FlxG.log.add(name + " worked out to death");
            UIController.updateDeathText(name + " has worked out to death!");
            return false;
        }

        if (workoutTime > maxWorkoutTime || FlxRandom.chanceRoll(workoutQuitChance)) {
            workingout = false;
            workoutTime = 0;
            return false;
        }

        return true;
    }

    private function sleep():Bool {
        if (!sleeping) {
            return false;
        }

        animation.play("sleep");
        sleepTime += FlxG.elapsed;

        if (FlxRandom.chanceRoll(statDecreaseChance)) {
            health += FlxRandom.floatRanged(0.05, 0.5);
            if (health > 1){
                health = 1;
            }
            sleepStat += FlxRandom.floatRanged(3, 8);
            if (sleepStat > 100) {
                sleepStat = 100;
            }
        }

        if (sleepTime > maxSleepTime || FlxRandom.chanceRoll(wakeUpChance)) {
            sleeping = false;
            sleepTime = 0;
            return false;
        }

        return true;
    }

    private function slam():Bool {
        if (!slamming) {
            return false;
        }

        animation.play("slam");
        danceTime += FlxG.elapsed;

        if (FlxRandom.chanceRoll(statDecreaseChance)){
            danceStat += FlxRandom.floatRanged(3, 8);
            angerStat -= FlxRandom.floatRanged(3, 8);
            if (danceStat > 100) {
                danceStat = 100;
            }
            if (angerStat < 0) {
                angerStat = 0;
            }
        }

        if (FlxRandom.chanceRoll(1)) {
            if (facing == FlxObject.RIGHT){
                facing = FlxObject.LEFT;
            } else {
                facing = FlxObject.RIGHT;
            }
        }

        if (FlxRandom.chanceRoll(punchChance)) {
            var target:Citizen = null;
            var tries = 0;
            while ((target == null || !target.alive) && tries < 5){
                target = state.citizens.getRandom();
                tries++;
            }
            if (tries < 5) {
                target.health -= FlxRandom.floatRanged(0.05, .25);
                FlxG.log.add(target.name + " has been slammed by " + name);
                var blood = new Blood(target.x + target.width/2, target.y + target.height/4, facing);
                state.blood.add(blood);
                if (target.health <= 0) {
                    UIController.updateDeathText(target.name + " has been slam danced to death by " + name);
                }
            }
        }

        if (danceTime > maxDanceTime/4*3 && FlxRandom.chanceRoll(danceDeathChance)) {
            this.health = 0;
            slamming = false;
            FlxG.log.add(name + " has slamed to death.");
            UIController.updateDeathText(name + " has slam danced to death.");
            return false;
        }

        if (danceTime > maxDanceTime) {
            slamming = false;
            danceTime = 0;
            return false;
        }

        return true;
    }

    private function rave():Bool {
        if (!raving) {
            return false;
        }
        if (FlxRandom.chanceRoll(statDecreaseChance)){
            danceStat += FlxRandom.floatRanged(3, 8);
            exersiceStat += FlxRandom.floatRanged(3, 8);
            if (danceStat > 100) {
                danceStat = 100;
            }
            if (exersiceStat > 100) {
                exersiceStat = 100;
            }
        }

        if (FlxRandom.chanceRoll(1)) {
            if (facing == FlxObject.RIGHT){
                facing = FlxObject.LEFT;
            } else {
                facing = FlxObject.RIGHT;
            }
        }

        if (danceTime > maxDanceTime/4*3 && FlxRandom.chanceRoll(danceDeathChance)) {
            this.health = 0;
            raving = false;
            FlxG.log.add(name + " has raved to death.");
            UIController.updateDeathText(name + " has raved to death.");
            return false;
        }

        if (danceTime > maxDanceTime) {
            raving = false;
            danceTime = 0;
            return false;
        }

        return true;
    }

    private function zombie():Bool {
        if (!zombieing) {
            return false;
        }

        animation.play("zombie");

        if (FlxRandom.chanceRoll(punchChance)) {
            var tries = 0;
            while((zombieTarget == null || zombieTarget == this || !zombieTarget.alive) &&  tries < 5) {
                zombieTarget = state.citizens.getRandom();
                tries++;
            }
            if (tries < 5 && Math.abs(FlxMath.distanceBetween(this, zombieTarget)) < 100) {
                zombieTarget.health -= FlxRandom.floatRanged(0.05, .25);
                FlxG.log.add(zombieTarget.name + " was bitten by " + name);
                var blood = new Blood(zombieTarget.x + zombieTarget.width/2, zombieTarget.y + zombieTarget.height/4, facing);
                state.blood.add(blood);
                if (zombieTarget.health <= 0) {
                    UIController.updateDeathText(zombieTarget.name + " was bitten to death by " + name);
                }
            }
            zombieTarget = null;
        }

        if (FlxRandom.chanceRoll(runChance)){
            zombieing = false;
            zombieTarget = null;
            return false;
        }

        zombieTime += FlxG.elapsed;
        if (zombieTime > maxZombieTime) {
            zombieing = false;
            zombieTarget = null;
            zombieTime = 0;
            return false;
        }

        return true;
    }

    public function clearTasks():Void {
        waiting = false;
        walking = false;
        walkTime = 0;
        fighting = false;
        dancing = false;
        danceTime = 0;
        zombieing = false;
        raving = false;
        slamming = false;
        zombieTarget = null;
        fightTarget = null;
    }

    override public function kill():Void {
        clearTasks();
        var blood = new Blood(this.x + this.width/2, this.y + this.height/4, facing);
        state.blood.add(blood);
        nameText.kill();
       // hair.kill();
        animation.play("death");
    }

    private function animCallback(name:String, frameNumber:Int, frameIndex:Int):Void {
        //FlxG.watch.addQuick("Frame Number", frameNumber);
        //FlxG.watch.addQuick("Frame Index", frameIndex);
        if (name == "death" && frameNumber >= 4) {
            super.kill();
        }
    }
}
