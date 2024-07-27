extends Node3D;

var current_position : Vector3 = Vector3.ZERO;
var room_count : int = 5;

func _ready() -> void:
	Generate();
	
func Generate() -> void:
	for i in range(room_count):
		pass;
