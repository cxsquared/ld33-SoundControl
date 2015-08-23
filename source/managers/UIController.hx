package managers;
import flash.media.Sound;
import PlayState;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.ui.FlxSlider;
import flixel.group.FlxGroup;
class UIController extends FlxGroup {

    public var metalSldr:FlxSlider;
    public var danceSldr:FlxSlider;
    public var chillSldr:FlxSlider;
    public var noiseSldr:FlxSlider;
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
        var sliderheight:Int = Std.int(((FlxG.height-this.y)/2) - (offset*2.5));
        var sliderwidth:Int = Std.int(FlxG.width/2 - (offset*2));
        FlxG.log.add(sliderwidth + ":" + sliderheight);
        metalSldr = new FlxSlider(SoundManager.soundLevels, "Metal", FlxG.width/4 - sliderwidth/2, (this.y + offset), 0, 1, sliderwidth, sliderheight, 3, FlxColor.RED);
        //metalSldr.x -= metalSldr.width/2;
        add(metalSldr);

        danceSldr = new FlxSlider(SoundManager.soundLevels, "Dance", FlxG.width*.75 - sliderwidth/2, (this.y + offset), 0, 1, sliderwidth, sliderheight, 3, FlxColor.BLUE);
        add(danceSldr);

        chillSldr = new FlxSlider(SoundManager.soundLevels, "Chill", FlxG.width/4 - sliderwidth/2, (this.y + sliderheight + offset*3), 0, 1, sliderwidth, sliderheight, 3, FlxColor.TEAL);
        add(chillSldr);

        noiseSldr = new FlxSlider(SoundManager.soundLevels, "Noise", FlxG.width*.75 - sliderwidth/2, (this.y + sliderheight + offset*3), 0, 1, sliderwidth, sliderheight, 3, FlxColor.WHEAT);
        add(noiseSldr);
    }

    override public function update():Void {
        super.update();

        if ((SoundManager.soundLevels.Metal >= 1 && SoundManager.soundLevels.Dance >= 1 && SoundManager.soundLevels.Chill >= 1 && SoundManager.soundLevels.Noise >= 1) || (SoundManager.soundLevels.Metal <= 0 && SoundManager.soundLevels.Dance <= 0 && SoundManager.soundLevels.Chill <= 0 && SoundManager.soundLevels.Noise <= 0)) {
            SoundManager.killAll = true;
        } else {
            SoundManager.killAll = false;
        }
    }
}
