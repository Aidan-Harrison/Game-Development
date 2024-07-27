extends Node;

@onready var character_file = preload("res://Character.gd");
var CHAR : Character = null;

func _ready() -> void:
	CHAR = character_file.new();
