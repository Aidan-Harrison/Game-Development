extends CharacterBody2D

@export var SPEED : float = 300.0;
@export var health : int = 1;
var direction : bool = true;

var world = null;

enum ABILITIES{F_SCORE_MOD, D_SCORE_MOD};
var abilityFlags = [true,true];

func _ready():
	world = get_parent();

func _physics_process(delta):
	velocity.x = SPEED;
	move_and_slide();

func TakeDamage(value : int) -> void:
	health -= value;
	if(health <= 0):
		var newAbility = null;
		var id = randi_range(0, 1);
		while(!abilityFlags[id]):
			id = randi_range(0, 1);
		match(id):
			0: # Flat score mod
				newAbility = Preloader.laser.instantiate();
			1: # Double score mod
				newAbility = Preloader.laser.instantiate();
		world.add_child(newAbility);
		newAbility.global_position = global_position;
		queue_free();
