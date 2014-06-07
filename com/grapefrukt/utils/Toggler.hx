package com.grapefrukt.utils;
import com.bit101.components.Accordion;
import com.bit101.components.CheckBox;
import com.bit101.components.HBox;
import com.bit101.components.HUISlider;
import com.bit101.components.Label;
import com.bit101.components.PushButton;
import com.bit101.components.VBox;
import com.bit101.components.Window;
import haxe.rtti.Meta;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.Lib;
import openfl.ui.Keyboard;
import openfl.ui.Mouse;
import Type;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */

class Property {
	public function new(){}
	
	public var name:String;
	public var type:ValueType;
	public var value:Dynamic;
	public var max:Float;
	public var min:Float;
	public var header:String = "";
	public var reset:Bool;
}

class Toggler extends Sprite {
		static private inline var WIDTH:Int = 400;

		private var targetClass:Dynamic;
		private var properties:Array<Property>;
		private var resetGame:Void->Void;
		private var reload:Void->Void;
		private var export:Void->Void;
		private var maxHeight:Float;
		
		public function new(targetClass:Dynamic, visible:Bool = false, maxHeight:Float = 0, resetGame:Void->Void = null, reload:Void->Void = null, export:Void->Void = null) {
			super();
			this.maxHeight = maxHeight;
			if (maxHeight < 0) maxHeight = Lib.current.stage.stageHeight;
			this.targetClass = targetClass;
			this.visible = visible;
			this.resetGame = resetGame;
			this.export = export;
			this.reload = reload;
			
			reset();
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		public function reset(targetClass:Dynamic = null) {
			if (targetClass != null) {
				this.targetClass = targetClass;
			} else {
				targetClass = this.targetClass;
			}
			
			var metadata = Meta.getStatics(targetClass);
			var fields = Type.getClassFields(targetClass);
			
			properties = [];
			var property:Property;
			
			for (field in fields) {
				//if (field == "__meta__") continue;
				//if (field == "init__") continue;
				
				// ignore fields that are not all caps
				var uc = field.toUpperCase();
				if (uc != field) continue;
				
				property = new Property();
				
				
				property.name = field;
				property.value = Reflect.field(targetClass, field);
				property.type = Type.typeof(Reflect.field(targetClass, field));
				property.header = getGroupName(field);
				
				//trace("field: " + field + " group: " + property.header);
				
				if (property.type == ValueType.TFloat || property.type == ValueType.TInt) {
					property.min = property.value / 2;
					property.max = property.value * 2;
				} else if (property.type == ValueType.TBool) {
					// do nothing
				} else {
					// dunno what this is, skipping
					continue;
				}
				
				var meta = Reflect.field(metadata, field);
				if (meta != null) {
					if (Reflect.hasField(meta, "hidden")) continue;
					
					var range = Reflect.field(meta, "range");
					if (range != null) {
						property.min = range[0];
						property.max = range[1];
					}
					
					var reset = Reflect.field(meta, "reset");
					if (reset == true) property.reset = true;
				}
				
				properties.push(property);
			}
			
			properties.sort(_sort);
			
			while (numChildren > 0) removeChildAt(0);
			
			var settingWindow:Window = new Window(this, 10, 10);
			settingWindow.title = "JUICEATRON 7001 ZZ";
			settingWindow.width = WIDTH;
			settingWindow.height = maxHeight - 50;
			
			var accordion:Accordion = new Accordion(settingWindow);
			var window:Window = null;
			
			for (property in properties) {
				if (window == null || (window.title != property.header && property.header != "")) {
					accordion.addWindowAt(property.header, accordion.numWindows);
					window = accordion.getWindowAt(accordion.numWindows - 1);
					var container:VBox = new VBox(window.content, 10, 10);
					trace("added new thing");
				}
				
				var row:HBox = new HBox(cast(window.content.getChildAt(0), DisplayObjectContainer));
				var label:Label = new Label(row, 0, 0, prettify(property.name, property.header));
				label.autoSize = false;
				label.width = 110;
				
				if (Type.enumEq(property.type, ValueType.TBool)) {
					var checkbox:CheckBox = new CheckBox(row, 0, 0, "");
					checkbox.selected = property.value;
					checkbox.addEventListener(Event.CHANGE, getToggleClosure(checkbox, property));
				} else if (Type.enumEq(property.type, ValueType.TFloat) || Type.enumEq(property.type, ValueType.TInt)) {
					var slider:HUISlider = new HUISlider(row, 0, 0, "");
					slider.width = 230;
					slider.tick = (property.max - property.min) / 100;
					slider.labelPrecision = 2;
					if (Type.enumEq(property.type, ValueType.TInt)) {
						slider.tick = 1;
						slider.labelPrecision = 0;
					}
					slider.minimum = property.min;
					slider.maximum = property.max;
					slider.value = property.value;
					slider.addEventListener(Event.CHANGE, getSliderClosure(slider, property));
				}
			}
			
			accordion.height = maxHeight - 50 - 20;
			accordion.width = WIDTH;
			
			#if !mobile
			if (export != null) {
				new PushButton(this, WIDTH + 20, 0, "Export", function(e:Event) {
					export();
				});
			}
			
			if (reload != null){
				new PushButton(this, WIDTH + 20, 30, "Import", function(e:Event) {
					reload();
				});
			}
			#end
		}
		
		private function prettify(name:String, header:String):String {
			name = StringTools.replace(name, header, "");
			name = StringTools.replace(name, "_", " ");
			return name;
		}
		
		private function getGroupName(name:String):String {
			return name.substr(0, name.indexOf("_"));
		}
		
		private function getToggleClosure(checkbox:CheckBox, property:Property) {
			return function(e:Event) {
				Reflect.setField(targetClass, property.name, checkbox.selected);
				if (property.reset && resetGame != null) resetGame();
			}
		}
		
		private function getSliderClosure(slider:HUISlider, property:Property) {
			return function(e:Event) {
				Reflect.setField(targetClass, property.name, slider.value);
				if (property.reset && resetGame != null) resetGame();
			}
		}
		
		private function handleAddedToStage(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		private function handleKeyDown(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.TAB) visible = !visible;
			if (visible) Mouse.show();
			if (!visible) Mouse.hide();
		}
		
		private function _sort(p1:Property, p2:Property):Int {
			if (p1.name < p2.name) return -1;
			if (p1.name > p2.name) return 1;
			return 0;
		}
	
}