package managers;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flash.media.Sound;
import PlayState;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.addons.ui.FlxSlider;
import flixel.group.FlxGroup;
class UIController extends FlxGroup {

    public var angerBar:FlxBar;
    public var sleepBar:FlxBar;
    public var exerciseBar:FlxBar;
    public var danceBar:FlxBar;

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
        setUpBars();
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

    private function setUpBars():Void {
        var barWidth:Int = Std.int(FlxG.width/4 - offset/2);
        var barHeight:Int = 10;
        angerBar = new FlxBar(offset/2, offset/2, FlxBar.FILL_LEFT_TO_RIGHT, barWidth, barHeight, state.citizens, "angerAverage", 0, 100);
        add(angerBar);
        var angerText = new FlxText(angerBar.x, angerBar.y + angerBar.height, angerBar.width, "Anger");
        angerText.alignment = "center";
        add(angerText);
        sleepBar = new FlxBar(angerBar.x + angerBar.width + offset/2, offset/2, FlxBar.FILL_LEFT_TO_RIGHT, barWidth, barHeight, state.citizens, "sleepAverage", 0, 100);
        add(sleepBar);
        var sleepText = new FlxText(sleepBar.x, sleepBar.y + sleepBar.height, sleepBar.width, "Sleep");
        sleepText.alignment = "center";
        add(sleepText);
        danceBar = new FlxBar(sleepBar.x + sleepBar.width  + offset/2, offset/2, FlxBar.FILL_LEFT_TO_RIGHT, barWidth, barHeight, state.citizens, "danceAverage", 0, 100);
        add(danceBar);
        var danceText = new FlxText(danceBar.x, danceBar.y + danceBar.height, danceBar.width, "Dance");
        danceText.alignment = "center";
        add(danceText);
        exerciseBar = new FlxBar(danceBar.x + danceBar.width  + offset/2, offset/2, FlxBar.FILL_LEFT_TO_RIGHT, barWidth, barHeight, state.citizens, "exerciseAverage", 0, 100);
        add(exerciseBar);
        var exerciseText = new FlxText(exerciseBar.x, exerciseBar.y + exerciseBar.height, exerciseBar.width, "Exercise");
        exerciseText.alignment = "center";
        add(exerciseText);
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
