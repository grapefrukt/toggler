package com.bit101.components;
import openfl.events.Event;
import openfl.text.TextFieldAutoSize;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class HeaderLabel extends Label {
	
	public var padLeft = 10;

	override public function draw():Void {
		dispatchEvent(new Event(Component.DRAW));
		
		_tf.text = _text;
		_tf.autoSize = TextFieldAutoSize.NONE;
		_tf.x = padLeft;
		_tf.width = _width - padLeft;
		_height = _tf.height = 18;
		
		graphics.clear();
		graphics.beginFill(Style.LIST_DEFAULT);
		graphics.drawRect(0, 0, _width, height);
		graphics.endFill();
	}
	
}