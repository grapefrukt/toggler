package com.grapefrukt.utils.toggler;
import com.grapefrukt.utils.toggler.properties.TogglerPropertyBase;
import com.grapefrukt.utils.toggler.properties.TogglerPropertyBool;
import com.grapefrukt.utils.toggler.properties.TogglerPropertyFloat;
import com.grapefrukt.utils.toggler.properties.TogglerPropertyInt;
import haxe.rtti.Meta;
import Type;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class TogglerCore {
	
	public var properties(default, null):Array<TogglerPropertyBase>;
	public var groups(default, null):Array<TogglerPropertyGroup>;
	
	public function new() {
		properties = [];
		groups = [];
	}
	
	public function addClass<T:Dynamic>(targetClass:Class<T>) {
		var metadata = Meta.getStatics(targetClass);
		var fields = Type.getClassFields(targetClass);
		
		for (field in fields) {
			// ignore fields that are not all caps
			if (field.toUpperCase() != field) continue;
			
			var type = Type.typeof(Reflect.field(targetClass, field));
			var property = getPropertyInstance(type);
			
			// if no supported TogglerProperty was found, ignore
			if (property == null) continue;
			
			property.name = field;
			property.value = Reflect.field(targetClass, field);
			property.group = getGroupName(field);
			property.min = property.value / 2;
			property.max = property.value * 2;
			
			applyMeta(property, Reflect.field(metadata, field));
			if (property.hidden) continue;
			
			add(property);
		}
		
		sortAlpha(groups);
		sortAlpha(properties);
	}
	
	function add(property:TogglerPropertyBase) {
		var group = null;
		for (existing in groups) {
			if (existing.name == property.group) {
				group = existing;
				break;
			}
		}
		
		if (group == null) {
			group = new TogglerPropertyGroup(property.group);
			groups.push(group);
		}
		
		group.properties.push(property);
		properties.push(property);
	}
	
	function getPropertyInstance(type:ValueType):TogglerPropertyBase {
		return switch(type){
			case TInt:		new TogglerPropertyInt();
			case TFloat:	new TogglerPropertyFloat();
			case TBool:		new TogglerPropertyBool();
			default : 		null;
		}
	}
	
	function getGroupName(name:String):String {
		return name.substr(0, name.indexOf("_"));
	}
	
	function applyMeta(property:TogglerPropertyBase, meta:Dynamic){
		if (meta == null) return;
		property.hidden = Reflect.hasField(meta, "hidden");
		
		var range = Reflect.field(meta, "range");
		if (range != null) {
			property.min = range[0];
			property.max = range[1];
		}
		
		property.reset = Reflect.field(meta, "reset");
		
	}
	
	function sortAlpha<T:{name:String}>(array:Array<T>){
		array.sort(function(a:T, b:T) {
			if (a.name < b.name) return -1;
			if (a.name > b.name) return 1;
			return 0;
		});
	}
}