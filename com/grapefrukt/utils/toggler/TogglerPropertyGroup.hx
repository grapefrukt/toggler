package com.grapefrukt.utils.toggler;
import com.grapefrukt.utils.toggler.properties.TogglerPropertyBase;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class TogglerPropertyGroup {

	public var name(default, null):String;
	public var properties(default, null):Array<TogglerPropertyBase>;
	
	public function new(name:String) {
		this.name = name;
		properties = [];
	}
	
}