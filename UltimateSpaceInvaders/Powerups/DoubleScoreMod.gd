extends Node2D

var isWorld : bool = false;
@export var fallSpeed : float = 300.0;

func _physics_process(delta):
	position.y += fallSpeed * delta;

func Activate(object):
	object.scoreModifier *= 2;
	object.scoreModTimer.start();
