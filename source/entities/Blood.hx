package entities;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter;
class Blood extends FlxEmitter {

    private var direction:Int = 0;
    private var maxParticles = 100;
    private var bloodPixel:FlxParticle;
    private var bloodLifeMin = 1.5;
    private var bloodLifeMax = 2.5;
    private var bloodTimer = new FlxTimer();

    public function new(X:Float=0, Y:Float=0, Direction:Int=0) {
        super(X, Y, maxParticles);

        direction = Direction;

        if (direction == FlxObject.LEFT) {
            setXSpeed(-200, -50);
        } else {
            setXSpeed(50, 200);
        }
        this.setYSpeed(-25, 25);
        this.gravity = 200;

        generateParticles();

        start(true, bloodLifeMin, 0, 0, 1);
        bloodTimer.start(bloodLifeMax, function(t:FlxTimer):Void {
            kill();
        }, 1);
    }

    private function generateParticles():Void {
        for (i in 0...(Std.int(this.maxSize/2))) {
            bloodPixel = new FlxParticle();
            bloodPixel.makeGraphic(2, 2, FlxColor.CRIMSON);
            bloodPixel.visible = false;
            bloodPixel.solid = true;
            add(bloodPixel);
            bloodPixel = new FlxParticle();
            bloodPixel.makeGraphic(1, 1, FlxColor.RED);
            bloodPixel.visible = false;
            bloodPixel.solid = true;
            add(bloodPixel);
        }
    }
}
