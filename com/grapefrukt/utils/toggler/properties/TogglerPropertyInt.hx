package com.grapefrukt.utils.toggler.properties;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class TogglerPropertyInt extends TogglerPropertyBase {
	
	var _value	:Int;
	var _max	:Int;
	var _min	:Int;

	public function new() {
		super();
	}
	
	override function get_value() return _value;
	override function set_value(value) return _value = value;
	
	override function get_max() return _max;
	override function set_max(value) return _max = value;
	
	override function get_min() return _min;
	override function set_min(value) return _min = value;
	
}