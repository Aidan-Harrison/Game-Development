extends Node2D

var isWorld : bool = false;
@export var fallSpeed : float = 300.0;

func _physics_process(delta):
	position.y += fallSpeed * delta;

func Activate(object):
	object.health += 3;
	if(object.health >= object.maxHealth):
		object.health = object.maxHealth;
	object.ui.health.value = object.health;
	object.ui.hValue.text = str(object.health);
	object.pText.text = "HEALTH";
	object.pText.modulate = Color.GREEN;
