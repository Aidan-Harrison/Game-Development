extends RigidBody3D

var parent = null;
var bounces : int = 0;
var isActive : bool = false;
var force : float = 200.0;
var thrown : bool = false;
var isOnFloor : bool = false;

var hasExploded : bool = false;
@onready var slowZone = preload("res://Agents/Sage/Slow_Zone.tscn");
@onready var areaCol = $Area3d/CollisionShape3d;

func _ready():
	areaCol.disabled = true;
	$CollisionShape3d.disabled = true;
	visible = false;

func Explode(): # Create slow zone
	set_process(false);
	gravity_scale = 3;
	var newSlowZone = slowZone.instantiate();
	parent.get_parent().add_child(newSlowZone);
	newSlowZone.global_position = global_position;
	newSlowZone.Start();
	hasExploded = true;
	$CollisionShape3d.disabled = true;

func _process(delta):
	if(!thrown):
		linear_velocity = Vector3.ZERO;
	if(bounces > 2 && isOnFloor):
		Explode();

func Execute() -> void: # Fire out
	set_as_top_level(true);
	$CollisionShape3d.disabled = false;
	apply_central_force(-transform.basis.z*force);

func Activate() -> void:
	if(thrown): # Create new instance internally
		thrown = false;
		print('NEW');
	if(isActive):
		isActive = false;
		visible = false;
		set_process(false);
		set_process_input(false);
		return;
	visible = true;
	isActive = true;
	set_process(true);
	set_process_input(true);

func _input(event):
	if(Input.is_action_just_pressed("Fire") && isActive):
		thrown = true;
		parent.hud.abi_2_count.value -= 1;
		areaCol.disabled = false;
		set_process_input(false);
		set_process(true);
		Execute();

func _on_area_3d_body_entered(body): # Fix initial bounce
	#if(body == parent):
		#return;
	bounces+=1;
	if(body.is_in_group("Environment")):
		if(hasExploded):
			visible = false;
		if(body.is_in_group("Floor")):
			isOnFloor = true;

func _on_area_3d_body_exited(body):
	if(body.is_in_group("Floor")):
		isOnFloor = false;
