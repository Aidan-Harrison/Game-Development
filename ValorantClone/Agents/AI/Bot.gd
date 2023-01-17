extends CharacterBody3D;

@export var SPEED = 5.0;
@export var team : int = 0;
var health : int = 100;
var dead : bool = false;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction;

func _ready():
	Players.bots.append(self);

func _physics_process(delta):
	if(!is_on_floor()):
		velocity.y -= gravity * delta;

	if(direction):
		velocity.x = direction.x * SPEED;
		velocity.z = direction.z * SPEED;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED);
		velocity.z = move_toward(velocity.z, 0, SPEED);

	move_and_slide();

func TakeDamage(damage : int) -> void:
	health -= damage;
	if(health <= 0):
		dead = true;
		#queue_free();
