extends Node2D

var isWorld : bool = false;
@export var fallSpeed : float = 300.0;

func _physics_process(delta):
	position.y += fallSpeed * delta;

func Activate(object):
	object.shield = 2;
	object.ui.shield.value = object.shield;
	object.pText.text = "SHIELD";
	object.pText.modulate = Color.CORNFLOWER_BLUE;
