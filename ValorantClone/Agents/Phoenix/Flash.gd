extends Node3D;

# Exports
@export var speed : float = 2.0;

# References
@onready var body : RigidBody3D = $RigidBody3d;
@onready var directionVector : Node3D = $RigidBody3d/DirVector;
@onready var flashTimer : Timer = $FlashTimer;
@onready var flashEntity = $FlashEntity;

var isActive : bool = false;

var parent = null;
var right : bool = false;
var forwardRampSpeed : float = 0.05;
var curveModifier : float = 0.05;

func _ready():
	set_physics_process(false);
	#Activate();

func _physics_process(delta):
	body.global_position = lerp(body.global_position, directionVector.global_position, -forwardRampSpeed);
	if(right):
		directionVector.position.x -= curveModifier;
	else:
		directionVector.position.x += curveModifier;
	curveModifier+=0.0001;
	directionVector.position = clamp(directionVector.position, Vector3(-6.0, 0.0, 3.0), Vector3(6.0,0.0,3.0));
	#directionVector.z += forwardRampSpeed;
	#body.global_position.z += directionVector.z;#*speed;
	#if(left):
		#body.global_position.x += -directionVector.x;
	#else:
		#body.global_position.x += directionVector.x;
	#directionVector.x += sidewaysRampSpeed;#+curveModifier;
	#curveModifier+=curveModifier/10;
	#body.apply_central_force(-transform.basis.z*directionVector.z-directionVector.x);
	#print(directionVector.position);

func Activate() -> void:
#	if(thrown): # Create new instance internally
#		thrown = false;
#		print('NEW');
	if(isActive):
		isActive = false;
		visible = false;
		#set_process(false);
		set_process_input(false);
		return;
	visible = true;
	isActive = true;
	#set_process(true);
	set_process_input(true);

func _input(event):
	if(Input.is_action_just_pressed("Fire") && isActive):
		flashTimer.start();
		set_as_top_level(true);
		right = false;
		#thrown = true;
		parent.hud.abi_2_count.value -= 1;
		#areaCol.disabled = false;
		set_process_input(false);
		#set_process(true);
		set_physics_process(true);
		#Execute();
	elif(Input.is_action_just_pressed("AltFire") && isActive):
		flashTimer.start();
		set_as_top_level(true);
		right = true;
		#thrown = true;
		parent.hud.abi_2_count.value -= 1;
		#areaCol.disabled = false;
		set_process_input(false);
		#set_process(true);
		set_physics_process(true);
		#Execute();

func _on_flash_timer_timeout():
	set_physics_process(false);
	flashEntity.Flash();
