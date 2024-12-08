package;

import flixel.FlxG;
import openfl.Lib;

// just a bunch of function can be used
class GameHandler
{
	// public static var version:String = Lib.application.meta.get("version");
	public static var versionA_M:String = "1.0.0";

	public static function exitGame(?exitActually:Bool = false)
	{
		if (exitActually)
			Sys.exit(0);
		else
			FlxG.switchState(new GameSelectionState());
	}
	// both like resizeGame and resizeWindow but this one can do both of them
	public static function resizeApp(w:Int, h:Int)
	{
		FlxG.resizeGame(w, h);
		FlxG.resizeWindow(w, h);
	}
}