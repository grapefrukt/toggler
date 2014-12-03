package com.grapefrukt.utils.toggler;
import com.bit101.components.HBox;
import com.bit101.components.HeaderLabel;
import com.bit101.components.HUISlider;
import com.bit101.components.HVBox;
import com.bit101.components.InputText;
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import com.bit101.components.ScrollPane;
import com.bit101.components.Style;
import com.bit101.components.VBox;
import com.bit101.components.Window;
import com.grapefrukt.utils.toggler.properties.TogglerPropertyBase;
import haxe.Timer;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.Lib;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class TogglerUI extends Sprite {
	
	static inline var WIDTH_TAB				= 80;
	static inline var WIDTH_SCROLLBAR		= 10;
	static inline var WIDTH_PROPERTY_LABEL	= 100;
	static inline var WIDTH_VALUE_INPUT		= 40;
	static inline var MARGIN_LIST			= 10;
	static inline var MARGIN_PROPERTY		= 5;
	static inline var MARGIN_HEADER			= 5;
	
	static inline var DRAG_RANGE			= 100;
	
	var core			:TogglerCore;
	var window			:Window;
	var pane			:ScrollPane;
	
	var dragProperty	:TogglerPropertyBase;
	var dragInput		:InputText;
	var dragStartX		:Float = 0;
	var dragStartValue	:Float = 0;
	
	public function new(core:TogglerCore) {
		super();
		this.core = core;
		
		Style.setStyle(Style.DARK);
		
		window = new Window(this, 20, 20);
		window.title = 'toggler';
		window.width = 400;
		window.height = 400;
		
		var tabs = new HVBox(window, 0, 0, window.width);
		pane = new ScrollPane(window);
		pane.width = window.width;
		
		var list = new VBox(pane, MARGIN_LIST, MARGIN_LIST);
		
		for (group in core.groups) {
			var tab = new PushButton(tabs);
			tab.width = WIDTH_TAB;
			tab.label = prettyPrint(group.name);
			
			var rowlabel = new HeaderLabel(list, 0, 0, '${group.name}');
			rowlabel.padLeft = MARGIN_HEADER;
			rowlabel.autoSize = false;
			rowlabel.width = pane.width - MARGIN_HEADER - MARGIN_LIST - WIDTH_SCROLLBAR;
			
			tab.addEventListener(MouseEvent.CLICK, getTabClosure(tab, rowlabel));
			
			for (property in group.properties) {
				var row = new HBox(list, MARGIN_PROPERTY);
				var label = new Label(row);
				label.autoSize = false;
				label.width = WIDTH_PROPERTY_LABEL;
				label.text = prettyPrint(property.name, '${group.name}_');
				label.mouseChildren = false;
				label.mouseEnabled = true;
				label.buttonMode = true;
				label.addEventListener(MouseEvent.MOUSE_OVER, handleLabelRoll);
				label.addEventListener(MouseEvent.MOUSE_OUT, handleLabelRoll);
				
				var input = new InputText(row);
				input.width = WIDTH_VALUE_INPUT;
				input.text = Std.string(roundToSignificant(property.value));
				
				label.addEventListener(MouseEvent.MOUSE_DOWN, getLabelClosure(input, property));
			}
		}
		
		var endPad = new Label(list);
		
		pane.y = tabs.height;
		
		pane.height = window.getMaxContentHeight() - tabs.height;
		pane.autoHideScrollBar = true;
		pane.dragContent = false;
		
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
	}
	
	function handleMouseUp(e:MouseEvent) {
		dragProperty = null;
	}
	
	function handleMouseMove(e:MouseEvent) {
		if (dragProperty == null) return;
		dragInput.text = Std.string(roundToSignificant(dragStartValue + dragStartValue * ((e.stageX - dragStartX) / DRAG_RANGE)));
	}
	
	function handleLabelRoll(e:MouseEvent) {
		var label:Label = cast e.target;
		label.textField.scrollH = e.type == MouseEvent.MOUSE_OVER ? label.textField.maxScrollH : 0;
	}
	
	function getTabClosure(tab:PushButton, rowlabel:HeaderLabel) {
		return function(e:Event){
			pane.scrollTo(0, rowlabel.y);
			blink(rowlabel);
		}
	}
	
	function getLabelClosure(input:InputText, property:TogglerPropertyBase) {
		return function(e:MouseEvent){
			dragProperty = property;
			dragInput = input;
			dragStartValue = property.value;
			dragStartX = e.stageX;
		}
	}
	
	function blink(target:DisplayObject, count:Int = 4, delayMS:Int = 75) {
		target.visible = !target.visible;
		
		if (count <= 0){
			target.visible = true;
			return;
		}
		
		Timer.delay(function(){
			blink(target, count - 1, delayMS);
		}, delayMS);		
	}
	
	function prettyPrint(string:String, removeLeading:String = '') {
		if (removeLeading != '' && string.indexOf(removeLeading) == 0) {
			string = string.substr(removeLeading.length);
		}
		return string.toLowerCase();
	}
	
	// http://stackoverflow.com/a/1581007
	static function roundToSignificant(num:Float, n:Int = 2) {
		if (num == 0) return .0;
		
		var d = Math.ceil(Math.log(num < 0 ? -num: num) * 0.4342944819032518); // log10 of value
		var power = n - Std.int(d);

		var magnitude = Math.pow(10, power);
		var shifted = Math.round(num * magnitude);
		return shifted / magnitude;
	}
	
}