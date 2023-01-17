extends Node3D

var parent = null;

# mark points at set intervals
# Create double sided plane
# lerp vertices along path

var isActive : bool = true;
var done : bool = false;

@onready var ray : RayCast3D = $RayCast3d;
@onready var wTimer : Timer = $WallGap;
@onready var totalTimer : Timer = $TotalTimer;

@onready var wallMat : StandardMaterial3D = preload("res://Materials/AgentSpecific/Phoenix/Phoenix_Wall.tres");

var wallPoints = [];
var walls = [];
var offset : float = 6.0;
var rotationValue : float = 0.0;

func _ready():
	set_process(false);

func _process(delta):
	#$Node3d.rotate_y(0.005);
	if(done):
		for i in walls: # Check global position
			i.position.y = lerp(i.position.y, 1.0, 0.1); # Go to wall height
	else:
		ray.global_position.z += 0.1;
		#ray.position.x = rotationValue;
		#parent.rotation.y;
		#ray.rotation.y = parent.rotation.y;

func Wall() -> void:
	for i in range(0, wallPoints.size()):
		pass

func Activate() -> void:
	print('PHOENIX WALL');
	if(isActive):
		isActive = false;
		visible = false;
		set_process_input(false);
		return;
	visible = true;
	isActive = true;
	set_process_input(true);

func _input(event):
	if(Input.is_action_just_pressed("Fire") && isActive):
		set_process(true);
		ray.set_as_top_level(true);
		totalTimer.start();
		wTimer.start();

func _on_wall_gap_timeout():
	if(ray.is_colliding()):
		var newPlane : MeshInstance3D = MeshInstance3D.new();
		parent.get_parent().add_child(newPlane);
		#add_child(newPlane); # Temp
		newPlane.set_as_top_level(true);
		newPlane.mesh = PlaneMesh.new();
		newPlane.mesh.size = Vector2(6.0,2.4);
		newPlane.mesh.material = wallMat;
		newPlane.look_at(ray.global_position, Vector3.RIGHT);
		walls.append(newPlane);
		newPlane.global_position = ray.get_collision_point();
		newPlane.global_position.y -= offset;
		wallPoints.append(ray.get_collision_point());
		offset += 0.5;

func _on_total_timer_timeout():
	#set_process(false);
	Wall();
	done = true;
	print('DONE');
