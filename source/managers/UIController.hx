package managers;
import PlayState;
import flixel.util.FlxColor;
import flixel.FlxG;
import entities.SoundManager;
import flixel.addons.ui.FlxSlider;
import flixel.group.FlxGroup;
class UIController extends FlxGroup {

    public var metalSldr:FlxSlider;
    public var y:Float = 0;
    public static var offset = 20;
    private var state:PlayState;

    public function new(State:PlayState=null, Y:Float=0) {
        super();

        this.y = Y;
        this.state = State;

        setUpSliders();
    }

    private function setUpSliders():Void {
        metalSldr = new FlxSlider(SoundManager.soundLevels, "Metal", FlxG.width/4 - (FlxG.width/2 - (offset*2))/2, (this.y + offset), 0, 1, cast(FlxG.width/2 - (offset*2), Int), cast((FlxG.height-this.y)/2 - (offset*2), Int), 3, FlxColor.RED, FlxColor.BLUE);
        //metalSldr.x -= metalSldr.width/2;
        add(metalSldr);
    }
}
