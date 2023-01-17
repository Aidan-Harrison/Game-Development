extends Node3D;

var rays = [];

func _ready():
	set_physics_process(false);
	rays.resize(Players.players.size());

func _physics_process(delta):
	for i in range(0, rays.size()):
		rays[i].target_position = Players.players[i].global_position;
		if(rays[i].is_colliding() && rays[i].get_collider().is_in_group("Player")):
			Players.players[i].Flash();

func Flash() -> void:
	for i in range(0, rays.size()):
		var newRay : RayCast3D = RayCast3D.new();
		add_child(newRay);
		rays[i] = newRay;
	set_physics_process(true);
	$Timer.start();

func _on_timer_timeout():
	set_physics_process(false);
