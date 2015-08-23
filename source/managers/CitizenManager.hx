package managers;
import flixel.FlxBasic;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.util.FlxRandom;
import entities.Citizen;
import flixel.group.FlxTypedGroup;
class CitizenManager extends FlxTypedGroup<Citizen> {

    private var state:PlayState;

    public var baseChance = 5;

    public var baseFightChance:Float = 15;
    public var baseRunChance:Float = .05;

    public var baseDanceChance:Float = 22;
    public var baseDanceToDeathChance:Float = .1;
    public var baseDanceQuitChance:Float = .5;

    public var baseSleepChance:Float = 20;

    public var baseWorkoutChane = 18;
    public var baseWorkoutDieChance = .15;
    public var baseWorkoutQuitChance = .6;

    public function new(State:PlayState = null) {
        super();
        this.state = State;
    }

    public function addCitizens(ammount:Int=1):Void {
        for (i in 0...ammount) {
            var citizen = new Citizen(FlxRandom.floatRanged(50, FlxG.width-50), 200, state);
            add(citizen);
        }
    }

    override public function update():Void {
        super.update();

        updateEmotions();
    }

    private function updateEmotions():Void {
        forEachAlive(updateAnger);
        forEachAlive(updateDance);
        forEachAlive(updateSleep);
        forEachAlive(updateWorkout);
        updateStats();
        updateSuicide();
    }

    private function updateAnger(t:FlxBasic):Void {
        var citizen = cast(t, Citizen);
        citizen.fightChance = Math.max(baseFightChance * Math.pow(SoundManager.soundLevels.Metal * 2, 2), baseChance);
        if (SoundManager.soundLevels.Metal > .75) {
            citizen.runChance = baseRunChance / Math.pow(SoundManager.soundLevels.Metal * 2, 2);
        } else {
            citizen.runChance = baseRunChance;
        }
        FlxG.watch.addQuick("Metal", SoundManager.soundLevels.Metal);
        FlxG.watch.addQuick("Fight chance", citizen.fightChance);
        FlxG.watch.addQuick("Run chance", citizen.runChance);
        FlxG.watch.addQuick("Suicide", citizen.killSelf);

    }

    private function updateDance(t:FlxBasic):Void {
        var citizen = cast(t, Citizen);
        if (SoundManager.soundLevels.Chill > .55) {
            citizen.danceChance = Math.max(baseDanceChance * Math.pow(SoundManager.soundLevels.Dance * 2 - SoundManager.soundLevels.Chill/1.5, 2), baseChance);
        } else {
            citizen.danceChance = Math.max(baseDanceChance * Math.pow(SoundManager.soundLevels.Dance * 2, 2), baseChance);
        }
        if (SoundManager.soundLevels.Dance > .75) {
            citizen.danceDeathChance = baseDanceToDeathChance * SoundManager.soundLevels.Dance * 1.5;
            citizen.danceQuitChance = baseDanceQuitChance / Math.pow(SoundManager.soundLevels.Dance * 1.5, 2);
        } else {
            citizen.danceDeathChance = baseDanceToDeathChance;
            citizen.danceQuitChance = baseDanceQuitChance;
        }
        FlxG.watch.addQuick("Dance Chance", citizen.danceChance);
        FlxG.watch.addQuick("Dance To Death", citizen.danceDeathChance);
        FlxG.watch.addQuick("Stop Dance", citizen.danceQuitChance);
    }

    private function updateSleep(t:FlxBasic):Void {
        var citizen = cast(t, Citizen);
        if (SoundManager.soundLevels.Metal >= .75 || SoundManager.soundLevels.Dance >= .75 || SoundManager.soundLevels.Noise >= .75) {
            citizen.sleepChance = 0;
        } else {
            citizen.sleepChance = Math.max(baseSleepChance * Math.pow(SoundManager.soundLevels.Chill * 2, 2), baseChance);
        }
        FlxG.watch.addQuick("Chance to sleep", citizen.sleepChance);
    }

    private function updateWorkout(t:FlxBasic):Void {
        var citizen = cast(t, Citizen);
        citizen.workoutChance = Math.max(baseWorkoutChane * Math.pow(((SoundManager.soundLevels.Dance * 2)+(SoundManager.soundLevels.Chill * 2))/2, 2), baseChance);
        if (SoundManager.soundLevels.Dance > .75 && SoundManager.soundLevels.Chill > .75) {
            citizen.workoutDeathChance = baseWorkoutDieChance * SoundManager.soundLevels.Dance * 1.5;
            citizen.workoutQuitChance = baseWorkoutQuitChance * SoundManager.soundLevels.Chill * 1.5;
        } else {
            citizen.workoutDeathChance = baseWorkoutDieChance;
            citizen.workoutQuitChance = baseWorkoutQuitChance;
        }
        FlxG.watch.addQuick("Workout chance", citizen.workoutChance);
        FlxG.watch.addQuick("Workout To Death", citizen.workoutDeathChance);
        FlxG.watch.addQuick("Stop workout", citizen.workoutQuitChance);
    }

    private function updateStats():Void {
        var angerAvg:Float = 0;
        var danceAvg:Float = 0;
        var sleepAvg:Float = 0;
        var exerciseAvg:Float = 0;
        for (citizen in this.members) {
            var c:Citizen = cast(citizen, Citizen);
            if (c.alive) {
                angerAvg += c.angerStat;
                danceAvg += c.danceStat;
                sleepAvg += c.sleepStat;
                exerciseAvg += c.exersiceStat;
            }
        }

        FlxG.watch.addQuick("Anger Average", angerAvg / countLiving());
        FlxG.watch.addQuick("Dance Average", danceAvg / countLiving());
        FlxG.watch.addQuick("Sleep Average", sleepAvg / countLiving());
        FlxG.watch.addQuick("Exercise Average", exerciseAvg / countLiving());
    }

    private function updateSuicide():Void {
        if (SoundManager.killAll) {
            setAll("killSelf", true);
        } else {
            setAll("killSelf", false);
        }
    }
}
