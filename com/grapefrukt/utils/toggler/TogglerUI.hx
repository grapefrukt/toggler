package com.grapefrukt.utils.toggler;
import com.bit101.components.HBox;
import com.bit101.components.HeaderLabel;
import com.bit101.components.HUISlider;
import com.bit101.components.HVBox;
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import com.bit101.components.ScrollPane;
import com.bit101.components.Style;
import com.bit101.components.VBox;
import com.bit101.components.Window;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class TogglerUI extends Sprite {
	
	static inline var WIDTH_TAB			= 80;
	static inline var WIDTH_SCROLLBAR	= 10;
	static inline var MARGIN_LIST		= 10;
	static inline var MARGIN_PROPERTY	= 5;
	static inline var MARGIN_HEADER		= 5;
	
	var core:TogglerCore;
	var window:Window;
	var pane:ScrollPane;

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
				var label = new Label(row, 0, 0, prettyPrint(property.name, '${group.name}_'));
				label.autoSize = false;
				label.width = 100;
				var slider = new HUISlider(row, 0, 0);
				slider.width = 220;
				slider.tick = (property.max - property.min) / 100;
				slider.labelPrecision = 2;
				slider.minimum = property.min;
				slider.maximum = property.max;
				slider.value = property.value;
			}
		}
		
		pane.y = tabs.height;
		
		pane.height = window.getMaxContentHeight() - tabs.height;
		pane.autoHideScrollBar = true;
		pane.dragContent = false;
	}
	
	function getTabClosure(tab:PushButton, rowlabel:HeaderLabel) {
		return function(e:Event){
			pane.scrollTo(0, rowlabel.y);
		}
	}
	
	function prettyPrint(string:String, removeLeading:String = '') {
		if (removeLeading != '' && string.indexOf(removeLeading) == 0) {
			string = string.substr(removeLeading.length);
		}
		return string.toLowerCase();
	}
	
}