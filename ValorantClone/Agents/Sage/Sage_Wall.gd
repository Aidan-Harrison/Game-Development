extends Node3D;

var isActive : bool = false;
var parent = null;

# References
@onready var wallCont = $Wall_Container;
@onready var anim = $AnimationPlayer;

# Preloader???
@onready var wallShatterVFX = preload("res://VFX/Agents/Sage/WallShatter.tscn");

var chunks = [];
var health = [100,100,100,100];

func _ready() -> void:
	visible = false;
	wallCont.visible = false;
	set_process(false);
	chunks = wallCont.get_children();
	for i in chunks:
		i.get_node("col").disabled = true;

func _process(delta) -> void:
	if(parent.aim.is_colliding()):
		global_position = parent.aim.get_collision_point();

func TakeDamage(damage : int, chunk) -> void: # Optimise, overcome StringName conversion!
	if(chunk == null):
		return;
	var tempName : String = str(chunk.name);
	var index = int(tempName[tempName.length()-1].to_int());
	health[index-1] -= damage;
	if(health[index-1] <= 0):
			var newShatterVFX = wallShatterVFX.instantiate();
			parent.get_parent().add_child(newShatterVFX);
			newShatterVFX.global_position = chunk.global_position;
			newShatterVFX.emitting = true;
			chunks[index-1].queue_free();

func Activate() -> void:
	if(isActive):
		isActive = false;
		visible = false;
		set_process(false);
		set_process_input(false);
		return;
	isActive = true;
	visible = true;
	set_process(true);
	set_process_input(true);

func Execute() -> void:
	$Timer.start();
	set_process(false);
	set_process_input(true);
	for i in chunks:
		i.get_node("col").disabled = false;
	isActive = false;
	wallCont.visible = true;
	$Indicator.visible = false;
	set_as_top_level(true);
	anim.play("Create");

func _input(event):
	if(Input.is_action_just_pressed("Fire") && isActive):
		Execute();
		parent.hud.abi_1_count.value -= 1;

func _on_timer_timeout():
	$OmniLight3d.visible = false;
	for i in chunks:
		TakeDamage(99999, i);
