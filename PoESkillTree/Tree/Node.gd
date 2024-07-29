extends Node2D;

# Core
@export_enum("MINOR", "MAJOR", "NOTABLE") var TYPE;
@export_enum("CORE", "DEFENCE", "RESISTANCE") var CORE_TYPE;
@export_enum("STRENGTH", "DEXTERITY", "INTELLIGENCE") var STAT_TYPE;
@export var ValueToGive : float = 10.0;
var Taken : bool = false;

@export var IsSingle : bool = false;
@export var PreviousNode : Node2D = null;
var NextNode : Node2D = null;

func _ready() -> void:
	match(TYPE):
		0: pass;
		1: scale *= 1.5;
		2: pass;
	match(STAT_TYPE):
		0: modulate = Color.FIREBRICK;
		1: modulate = Color.WEB_GREEN;
		2: modulate = Color.SKY_BLUE;
	if(PreviousNode != null):
		PreviousNode.NextNode = self;

func _on_button_pressed() -> void:
	var cont : bool = false;
	if(PreviousNode == null && !IsSingle):
		return;
	if(PreviousNode == null && IsSingle):
		cont = true;
	if(!cont):
		if(!PreviousNode.Taken && !IsSingle):
			return;
	if(Taken):
		if(NextNode != null && NextNode.Taken):
			return;
		match(TYPE):
			0:
				match(CORE_TYPE):
					0: FunctionSet.STAT_ADJUST_CORE(0, -ValueToGive);
					1: FunctionSet.STAT_ADJUST_DEFENCE(0, -ValueToGive);
					2: FunctionSet.STAT_ADJUST_RESISTANCE(0, -ValueToGive);
			1:
				pass;
			2:
				pass;
		Taken = false;
	else:
		match(TYPE):
			0:
				match(CORE_TYPE):
					0: FunctionSet.STAT_ADJUST_CORE(0, ValueToGive);
					1: FunctionSet.STAT_ADJUST_DEFENCE(0, ValueToGive);
					2: FunctionSet.STAT_ADJUST_RESISTANCE(0, ValueToGive);
			1:
				pass;
			2:
				pass;
		Taken = true;
