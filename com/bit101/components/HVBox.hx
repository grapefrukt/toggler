package com.bit101.components;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.events.Event;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class HVBox extends HBox {

	public var maxWidth(get, set):Float;
	var _maxWidth:Float = 300;
	
	public function new(parent:DisplayObjectContainer = null, xpos:Float = 0, ypos:Float = 0, maxWidth:Float = 300) {
		super(parent, xpos, ypos);
		this.maxWidth = maxWidth;
		spacing = 0;
	}
	
	override public function draw() {
		_width = _maxWidth;
		_height = 0;
		
		var xpos = .0;
		var row = 0;
		
		var maxItemHeight = .0;
		for (i in 0 ... numChildren) maxItemHeight = Math.max(maxItemHeight, getChildAt(i).height);
		
		for (i in 0 ... numChildren){
			var child = getChildAt(i);
			child.x = xpos;
			if (child.x + child.width > _maxWidth) {
				row++;
				child.x = 0;
				
			}
			child.y = row * maxItemHeight;
			xpos = child.x + child.width + _spacing;
			
			_height = Math.max(_height, child.y + child.height);
		}
		
		dispatchEvent(new Event(Event.RESIZE));
	}
	
	override function doAlignment() {
		
	}
	
	function get_maxWidth() return _maxWidth;
	function set_maxWidth(value:Float) return _maxWidth = value;
	
}