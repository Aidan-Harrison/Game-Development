extends Node2D;

@onready var Cam : Camera2D = $Camera2D;
@onready var CharacterRef : PackedScene = preload("res://Character/Character.tscn");
@onready var CharacterDisplay : Control = $StatDisplay;

var CurrentCharacter = null;

func _ready() -> void:
	CurrentCharacter = CharacterRef.instantiate();
	add_child(CurrentCharacter);
	FunctionSet.ActiveCharacter = CurrentCharacter;
	FunctionSet.CharacterDisplay = CharacterDisplay;

func _input(event) -> void:
	pass;
