package managers;
import flixel.FlxG;
import flixel.util.FlxRandom;
import entities.Citizen;
import flixel.group.FlxTypedGroup;
class CitizenManager extends FlxTypedGroup<Citizen> {
    public function new() {
        super();
    }

    public function addCitizens(ammount:Int=1):Void {
        for (i in 0...ammount) {
            var citizen = new Citizen(FlxRandom.floatRanged(50, FlxG.width-50), 200, this);
            add(citizen);
        }
    }

    override public function update():Void {
        super.update();

        updateEmotions();
    }

    private function updateEmotions():Void {
        
    }
}
