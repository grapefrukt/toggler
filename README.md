toggler
=======

Toggler is a library that provides a minimal interface to tweak configuration variables at runtime

It uses a slightly modified version of [MinimalCompsHX](https://github.com/Beeblerox/MinimalCompsHX)

###Usage###

In your project, create and add a Toggler instance to the display list:
```haxe
var t = new Toggler(Settings, false, 750);
addChild(t);
```

The only required argument is the target class (`Settings` in this example), the second argument is wether to show the Toggler initially and the third is the maximum window height allowed. If you want to show/hide the Toggler at runtime, toggle its `visible` property using your own code. 

In your target class (again, `Settings` in this example) any static public variable will be automatically populated in the Toggler:
```haxe
public static var SOUND_MUSIC_FADEIN_DURATION   :Float = 1.0;
public static var SOUND_MUSIC_FADEOUT_DURATION  :Float = 1.0;
public static var SCREENSHAKE_SPEED_MULTIPLIER  :Float = 0.2;
public static var SCREENSHAKE_CUT_DURATION      :Float = 1.201;
```

Settings are grouped on the part before the first underscore. Variables without underscores may not work. 

You can provide extra metadata to help the Toggler. 
```haxe
@range(1, 100)	public static var ASTEROID_AGE_MAX  :Float = 80;
@hidden         public static var SECRET_STUFF      :Bool = true;
@reset          public static var GAME_CHANGER      :Int = 24;
```

Range defines the maximum and minimum values allowed. Toggler tries to infer these when possible. 
Hidden will hide the variable from the Toggler. 
Reset will call the reset function supplied to the Toggler constructor whenever changed. 
