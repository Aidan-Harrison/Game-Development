extends Node2D;

# Core
@export_enum("MINOR", "MAJOR", "NOTABLE") var TYPE;
@export_enum("CORE", "DEFENCE", "RESISTANCE") var CORE_TYPE;
@export_enum("STRENGTH", "DEXTERITY", "INTELLIGENCE") var STAT_TYPE;
@export var ValueToGive : float = 10.0;
var Taken : bool = false;

@export var IsSingle : bool = false;
@export var PreviousNode : Node2D = null;
@export var Line : Line2D = null;
@export var PreviousNodes : Array[Node2D] = []; # Adopt this method instead
var NextNode : Node2D = null;
@export var Description = "";

@onready var button : Button = $Button;
@onready var Background : ColorRect = $Background;

func _ready() -> void:
	match(TYPE):
		0: pass; # Nothing
		1: scale *= 1.5;
		2: scale *= 1.75;
		_:
			pass;
	match(STAT_TYPE):
		0: button.modulate = Color.FIREBRICK;
		1: button.modulate = Color.WEB_GREEN;
		2: button.modulate = Color.SKY_BLUE;
		_: button.modulate = Color.DIM_GRAY;
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
		if(TYPE == 0 || TYPE == 1):
			match(CORE_TYPE):
				0: FunctionSet.STAT_ADJUST_CORE(0, -ValueToGive);
				1: FunctionSet.STAT_ADJUST_DEFENCE(0, -ValueToGive);
				2: FunctionSet.STAT_ADJUST_RESISTANCE(0, -ValueToGive);
		else: # Notable, unique function
			pass;
		Taken = false;
		Background.color = Color.DIM_GRAY;
		if(Line != null):
			Line.default_color = Color.GRAY;
	else:
		if(TYPE == 0 || TYPE == 1):
			match(CORE_TYPE):
				0: FunctionSet.STAT_ADJUST_CORE(0, ValueToGive);
				1: FunctionSet.STAT_ADJUST_DEFENCE(0, ValueToGive);
				2: FunctionSet.STAT_ADJUST_RESISTANCE(0, ValueToGive);
		else: # Notable, unique function
			pass;
		Taken = true;
		Background.color = Color.GOLD;
		if(Line != null):
			Line.default_color = Color.GOLD;

func _on_button_mouse_entered() -> void:
	FunctionSet.CurrentTooltip.visible = true;
	FunctionSet.CurrentTooltip.position = position + Vector2(20.0, 20.0);
	# Set description
	if(TYPE == 0 || TYPE == 1):
		match(STAT_TYPE): 
			0: FunctionSet.CurrentTooltip.Text.text = "+" + str(ValueToGive) + " Strength";
			1: FunctionSet.CurrentTooltip.Text.text = "+" + str(ValueToGive) + " Dexterity";
			2: FunctionSet.CurrentTooltip.Text.text = "+" + str(ValueToGive) + " Intelligence";
	else: # Notable specific description
		if(Description == ""):
			FunctionSet.CurrentTooltip.Text.text = "INVALID NOTABLE DESCRIPTION";
		else:
			FunctionSet.CurrentTooltip.Text.text = Description;
func _on_button_mouse_exited() -> void:
	FunctionSet.CurrentTooltip.visible = false;
