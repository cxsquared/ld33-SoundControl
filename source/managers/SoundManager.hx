package managers;
import flixel.FlxG;
import flixel.system.FlxSound;
class SoundManager {

    public static var soundLevels = {Metal:0.5, Noise:0.5, Dance:0.5, Chill:0.5};
    public static var killAll = false;

    public static var metal:FlxSound  = new FlxSound();
    public static var dance:FlxSound = new FlxSound();
    public static var noise:FlxSound = new FlxSound();
    public static var chill:FlxSound = new FlxSound();

    private static var numberOfSongsLoaded = 0;

    public static function init() {
        FlxG.log.add("Sound itniut");
        soundLevels.Metal = 0;
        soundLevels.Noise = 0;
        soundLevels.Dance = 0;
        metal.loadEmbedded(AssetPaths.metal__mp3, true, false);
        metal.play();
        dance.loadEmbedded(AssetPaths.dance__mp3, true, false);
        dance.play();
        noise.loadEmbedded(AssetPaths.noise__mp3, true, false);
        noise.play();
        chill.loadEmbedded(AssetPaths.chill__mp3, true, false);
        chill.play();
    }

    private static function soundLoaded():Void {
        numberOfSongsLoaded++;
        FlxG.log.add("Sound added " + numberOfSongsLoaded);
        if (numberOfSongsLoaded >= 4) {
            playMusic();
        }
    }

    private static function playMusic():Void {
        FlxG.log.add("playing music");
        metal.play();
        dance.play();
        noise.play();
        chill.play();
    }

    public static function update():Void {
        metal.volume = soundLevels.Metal;
        dance.volume = soundLevels.Dance;
        chill.volume = soundLevels.Chill;
        noise.volume = soundLevels.Noise;
    }
}
