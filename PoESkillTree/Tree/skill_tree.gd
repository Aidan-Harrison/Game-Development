extends Node2D;

@onready var Cam : Camera2D = $Camera2D;
@onready var CharacterRef : PackedScene = preload("res://Character/Character.tscn");
@onready var CharacterDisplay : Control = $Camera2D/StatDisplay;
@onready var Background : ColorRect = $Background;

var CurrentCharacter = null;

var IsPanningCamera : bool = false;
var Mouse : Vector2 = Vector2.ZERO;

func _ready() -> void:
	# Go through nodes and build tree
	for node in get_children():
		if(node.is_in_group("Node") && node.PreviousNode != null):
			var NewLine : Line2D = Line2D.new();
			add_child(NewLine); # Add to nodes to change line visuals! | DO
			NewLine.add_point(node.PreviousNode.position);
			NewLine.add_point(node.position);
			NewLine.width = 5.0;
			NewLine.default_color = Color.BISQUE;
			NewLine.z_index = -1;
	
	CurrentCharacter = CharacterRef.instantiate();
	add_child(CurrentCharacter);
	FunctionSet.ActiveCharacter = CurrentCharacter;
	FunctionSet.CharacterDisplay = CharacterDisplay;
	FunctionSet.REFRESH_DISPLAY();

func _process(delta) -> void:
	if(!IsPanningCamera):
		return;
	Cam.position -= Mouse;
	Mouse = Vector2.ZERO;

func _input(event) -> void:
	if(event is InputEventMouseMotion): 
		Mouse = event.relative;
	if(Input.is_action_just_pressed("RightClick")):
		IsPanningCamera = true;
	elif(Input.is_action_just_released("RightClick")):
		IsPanningCamera = false;
	if(Input.is_action_pressed("ScrollUp")):
		Cam.zoom += Vector2(0.1, 0.1);
	elif(Input.is_action_pressed("ScrollDown")):
		Cam.zoom -= Vector2(0.1, 0.1);
