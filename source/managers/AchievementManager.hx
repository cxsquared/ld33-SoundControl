package managers;

#if flash
import flixel.util.FlxSave;
import flash.utils.ByteArray;
import flixel.FlxG;
import flixel.addons.api.FlxGameJolt;

@:file("assets/data/myKey.privatekey") class MyKey extends ByteArray {}

class AchievementManager {
	private static var initialized:Bool = false;
	private static var gameID = 88203;

	private static var highScore = 0;
	private static var scoreBoardID = 91654;

	private static var numberOfDead = 0;

	// Achievements
	private static var youAreTheMonsterID = 39649;
	private static var raveMasterID = 39651;
	private static var pileOfBociesID = 39648;
	private static var fightClubID = 39652;
	private static var boredID = 19653;
	private static var mayorOfHappyTownID = 39650;

	private static var unlocked = {
		monster: false,
		rave: false,
		bodies: false,
		fight: false,
		bored: false,
		mayor: false
	};

	public static function init():Void {
		if (!initialized) {
			var byte = new MyKey();
			FlxGameJolt.init(88203, byte.readUTFBytes(byte.length));

			load();

			initialized = true;
		}
	}

	public static function submitScore(score:Int):Void {
		if (!initialized)
			init();
		if (score > highScore) {
			FlxG.log.add("New Highscore = " + score);
			highScore = score;
			if (highScore >= 15) {
				AchievementManager.unlockMayorOfHappyTown();
			}
			saveHighscore();
			FlxGameJolt.addScore((Std.string(score) + " Citizens"), score, scoreBoardID);
		}
	}

	public static function unlockRaveMaster():Void {
		if (!initialized)
			init();
		if (!unlocked.rave) {
			FlxGameJolt.addTrophy(raveMasterID);
			FlxG.log.add("Rave master");
			unlocked.rave = true;
		}
	}

	public static function unlockYouAreTheMonster():Void {
		if (!initialized)
			init();
		if (!unlocked.monster) {
			FlxGameJolt.addTrophy(youAreTheMonsterID);
			FlxG.log.add("You are the monter");
			unlocked.monster = true;
		}
	}

	private static function unlockPileOfBodies():Void {
		if (!initialized)
			init();
		if (numberOfDead >= 20 && !unlocked.bodies) {
			FlxGameJolt.addTrophy(pileOfBociesID);
			FlxG.log.add("Pile of Bodies");
			unlocked.bodies = true;
		}
	}

	public static function unlockFightClub():Void {
		if (!initialized)
			init();
		if (!unlocked.fight) {
			FlxGameJolt.addTrophy(fightClubID);
			FlxG.log.add("Fight Club");
			unlocked.fight = true;
		}
	}

	public static function unlockBored():Void {
		if (!initialized)
			init();
		if (!unlocked.bored) {
			FlxGameJolt.addTrophy(boredID);
			FlxG.log.add("Bored...");
			unlocked.bored = true;
		}
	}

	public static function unlockMayorOfHappyTown():Void {
		if (!initialized)
			init();
		if (!unlocked.mayor) {
			FlxGameJolt.addTrophy(mayorOfHappyTownID);
			FlxG.log.add("Mayor Of Happy Town");
			unlocked.mayor = true;
		}
	}

	private static function load():Void {
		FlxG.save.bind("soundControl");
		if (FlxG.save.data.highScore != null) {
			// highScore = FlxG.save.data.highScore;
		}
		if (FlxG.save.data.numberOfDead != null) {
			numberOfDead = FlxG.save.data.numberOfDead;
		}
	}

	private static function saveHighscore():Void {
		FlxG.save.bind("soundControl");
		FlxG.save.data.highScore = highScore;
		FlxG.save.flush();
	}

	private static function saveDead():Void {
		FlxG.save.bind("soundControl");
		FlxG.save.data.numberOfDead = numberOfDead;
		FlxG.save.flush();
	}

	public static function addDead():Void {
		numberOfDead++;
		unlockPileOfBodies();
		saveDead();
	}
}
#end
