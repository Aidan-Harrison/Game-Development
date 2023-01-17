extends Node3D

@onready var col = $Area3d/CollisionShape3d;
@onready var decal = $Decal;
@onready var rotationPoint = $RotationPoint;
@onready var ray = $RotationPoint/RayCast3d;
@onready var lTimer = $Timer;
@onready var tTimer = $TickTimer;

@onready var texture = preload("res://Textures/Agents/Sage/SageWallTexture.png");

var offset : Vector3 = Vector3.ZERO;
var decals = [];
var effectSize : float = 0.75;

func _ready() -> void:
	visible = false;
	
func _process(delta):
	rotationPoint.rotate_y(0.2);
	col.shape.radius = lerp(col.shape.radius, 4.0, 0.05);
	$GpuParticles3d.scale = lerp($GpuParticles3d.scale, Vector3(0.8,0.8,0.8), 0.0075);
	for i in decals:
		i.extents = lerp(i.extents, Vector3(effectSize,effectSize,effectSize), 0.05);

func Start() -> void:
	visible = true;
	lTimer.start();
	tTimer.start();
	set_process(true);
	$GpuParticles3d.emitting = true;

func _on_tick_timer_timeout():
	ray.position.x += 0.075;
	if(ray.is_colliding()):
		var newEffect : Decal = Decal.new();
		add_child(newEffect);
		newEffect.texture_albedo = texture;
		newEffect.global_position = ray.get_collision_point();
		newEffect.rotation.y = randf_range(0.0, 180.0);
		decals.append(newEffect);
	effectSize += 0.0075;
	# Adjust
#	offset.x += 1.0;
#	if(offset.x >= 6.0):
#		offset.x = 0;
#		offset.z += 1.0;
#		if(offset.x >= 6.0):
#			tTimer.stop();

func _on_timer_timeout():
	#set_process(false);
	tTimer.stop();
	set_process(false);
