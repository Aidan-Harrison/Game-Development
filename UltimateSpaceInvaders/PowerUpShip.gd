extends CharacterBody2D

@export var SPEED : float = 300.0;
@export var health : int = 3;
var direction : bool = true;

var world = null;

enum POWERS{HEALTH,SHIELD,D_SHOT,FLAT_S_MOD,D_SCORE_MOD};
var powerFlags = [true,true,true,true,true];

func _ready():
	world = get_parent();

func _physics_process(delta):
	velocity.x = SPEED;
	move_and_slide();

func TakeDamage(value : int) -> void:
	health -= value;
	if(health <= 0):
		var newPower = null;
		var id = randi_range(0, 4);
		while(!powerFlags[id]):
			id = randi_range(0, 4);
		match(id):
			0: #HEALTH
				newPower = Preloader.healthPickup.instantiate(); # Prevent spawning if max health
			1: #DOUBLE SHOT
				newPower = Preloader.dShotPickup.instantiate();
			2: #SHIELD
				newPower = Preloader.shieldPickup.instantiate();
			3: #FLAT SCORE MOD
				newPower = Preloader.flatScoreModPickup.instantiate();
			4: #DOUBLE SCORE MOD
				newPower = Preloader.doubleScoreModPickup.instantiate();
		world.add_child(newPower); 
		newPower.global_position = global_position;
		queue_free();
