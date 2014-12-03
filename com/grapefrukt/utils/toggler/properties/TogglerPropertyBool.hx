package com.grapefrukt.utils.toggler.properties;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class TogglerPropertyBool extends TogglerPropertyBase {

	var _value	:Bool;
	
	public function new() {
		super();
	}
	
	override function get_value() return _value;
	override function set_value(value) return _value = value;
	
	override function get_max() return 1;
	override function set_max(value) return 1;
	
	override function get_min() return 0;
	override function set_min(value) return 0;
	
}