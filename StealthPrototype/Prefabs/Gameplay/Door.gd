extends StaticBody3D;

@export var health    : float = 300.0;
@export var is_locked : bool = false;

func TakeDamage(damage_to_take : float) -> void:
	health -= damage_to_take;
	if(health <= 0):
		queue_free();

func Activate() -> void:
	pass;
