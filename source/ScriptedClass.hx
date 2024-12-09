package;

import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import sys.FileSystem;

using StringTools;

// This one will like emulated again the FlxState
// On script, try using `Action.moveTo("<file>", [<have any args if needed>]);`
class ScriptedClass extends FlxUIState
{
	public var script:HScript = null;

	public static var instance:ScriptedClass = null;
	public static var trackerFolder:Int = 0;

	public function new(filePath:String, ?args:Array<Dynamic>)
	{
		super();
		instance = this;
		trackerFolder = PlayState.trackerFolder;
		try
		{
			var foldersToCheck:Array<String> = [];
			foldersToCheck.push('mods/' + PolyHandler.trackedMods[trackerFolder].id + '/data/classes/');
			for (folder in foldersToCheck)
			{
				if (FileSystem.exists(folder) && FileSystem.isDirectory(folder))
				{
					for (file in FileSystem.readDirectory(folder))
					{
						if (file.startsWith(filePath) && file.endsWith('.hxs'))
						{
							filePath = folder + file;
						}
					}
				}
			}
			script = new HScript(filePath, false);
			script.execute(filePath, false);
			
			scriptExecute("new", args);
		}
		catch (e:Dynamic)
		{
			script = null;
			trace('Error getting script from $filePath!\n$e');
		}
	}

	override function create()
	{
		scriptExecute("onCreate", []);
		super.create();
		scriptExecute("onCreatePost", []);
	}

	override function update(elapsed:Float)
	{
		scriptExecute("onUpdate", [elapsed]);
		super.update(elapsed);

		if (FlxG.keys.justPressed.F4) // emergency exit
		{
			FlxG.switchState(new GameSelectionState());
		}

		scriptExecute("onUpdatePost", [elapsed]);
	}

	override function destroy()
	{
		scriptExecute("onDestroy", []);
		super.destroy();
	}

	function scriptExecute(func:String, args:Array<Dynamic>)
	{
		try
		{
			script?.call(func, args);
		}
		catch (e:Dynamic)
		{
			trace('Error executing $func!\n$e');
		}
	}
}