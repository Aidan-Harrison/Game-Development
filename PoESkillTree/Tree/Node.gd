extends Node2D;

enum TYPE{MINOR, MAJOR, NOTABLE};
enum CORE_TYPE{CORE, DEFENCE, RESISTANCE};
enum STAT_TYPE{STRENGTH, DEXTERITY, INTELLIGENCE};

# Core
@export var TYPE_ID : int = TYPE.MAJOR;
@export var CORE_TYPE_ID : int = CORE_TYPE.CORE;
@export var STAT_TYPE_ID : int = STAT_TYPE.STRENGTH;
@export var ValueToGive : float = 1.0;

func _ready() -> void:
	match(STAT_TYPE_ID):
		STAT_TYPE.STRENGTH:
			modulate = Color.FIREBRICK;
		STAT_TYPE.DEXTERITY:
			modulate = Color.WEB_GREEN;
		STAT_TYPE.INTELLIGENCE:
			modulate = Color.SKY_BLUE;

func _on_button_pressed() -> void:
	match(TYPE_ID):
		TYPE.MINOR:
			match(CORE_TYPE_ID):
				CORE_TYPE.CORE:
					FunctionSet.STAT_ADJUST_CORE(0, ValueToGive);
				CORE_TYPE.DEFENCE:
					FunctionSet.STAT_ADJUST_DEFENCE(0, ValueToGive);
				CORE_TYPE.RESISTANCE:
					FunctionSet.STAT_ADJUST_RESISTANCE(0, ValueToGive);
		TYPE.MAJOR:
			pass;
		TYPE.NOTABLE:
			pass;
