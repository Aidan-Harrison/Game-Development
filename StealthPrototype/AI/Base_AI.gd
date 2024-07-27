extends CharacterBody3D;

# Gameplay
@export var health      : float = 100.0;
@export var main_weapon : int = 0;
@export var sub_weapon  : int = 1;
var can_be_assasinated  : bool = false;

# Physics
var move_speed : float = 5.0;
var acceleration : float = move_speed * 2;

# AI
var direction : Vector3 = Vector3.ZERO;
var next_position : Vector3 = Vector3.ZERO;
var target = null;

# References
@onready var nav : NavigationAgent3D = $NavigationAgent3D;

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");

func _ready() -> void:
	match(sub_weapon):
		1:
			pass;

func _physics_process(delta) -> void:
	nav.target_position = next_position;
	direction = nav.get_next_path_position() - global_position;
	direction = direction.normalized();
	
	velocity = lerp(velocity, direction * move_speed, acceleration * delta);
	
	if(!is_on_floor()):
		velocity.y -= gravity * delta;
		
	move_and_slide();
	
	#look_at(next_position, Vector3.UP);

func TakeDamage(damage_to_take : float) -> void:
	health -= damage_to_take;
	if(health <= 0):
		Die();

func Die() -> void:
	queue_free();

func _on_area_3d_body_entered(body) -> void:
	if(body.is_in_group("Player")):
		can_be_assasinated = true;

func _on_area_3d_body_exited(body) -> void:
	if(body.is_in_group("Player")):
		can_be_assasinated = false;
