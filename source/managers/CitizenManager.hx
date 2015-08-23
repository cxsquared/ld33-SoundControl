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
        citizen.danceChance = Math.max(baseDanceChance * Math.pow(SoundManager.soundLevels.Dance * 2, 2), baseChance);
        if (SoundManager.soundLevels.Dance > .75) {
            citizen.danceDeathChance = baseDanceToDeathChance * SoundManager.soundLevels.Dance * 1.5;
            citizen.danceQuitChance = baseDanceQuitChance / Math.pow(SoundManager.soundLevels.Metal * 1.5, 2);
        } else {
            citizen.danceDeathChance = baseDanceToDeathChance;
            citizen.danceQuitChance = baseDanceQuitChance;
        }
        FlxG.watch.addQuick("Dance Chance", citizen.danceChance);
        FlxG.watch.addQuick("Dance To Death", citizen.danceDeathChance);
        FlxG.watch.addQuick("Stop Dance", citizen.danceQuitChance);
    }

    private function updateSuicide():Void {
        if (SoundManager.killAll) {
            setAll("killSelf", true);
        } else {
            setAll("killSelf", false);
        }
    }
}
