package com.grapefrukt.utils.toggler.properties;
import Type;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class TogglerPropertyBase {
	
	public var name		:String;
	public var type		:ValueType;
	public var group	:String = "";
	
	public var hidden	:Bool = false;
	public var reset	:Bool = false;
	public var hasMax	:Bool = false;
	public var hasMin	:Bool = false;
	
	public var value(get, set)	:Dynamic;
	public var max(get, set)	:Dynamic;
	public var min(get, set)	:Dynamic;
	
	public function new() {
		
	}
	
	function get_value():Dynamic return 0;
	function set_value(value:Dynamic):Dynamic return 0;
	
	function get_max():Dynamic return 0;
	function set_max(value:Dynamic):Dynamic return 0;
	
	function get_min():Dynamic return 0;
	function set_min(value:Dynamic):Dynamic return 0;
	
}