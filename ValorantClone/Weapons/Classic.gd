extends Node3D

@export var damage : int = 25;

var magSize : int = 0;
@onready var anim = $AnimationPlayer;
@onready var ray = $Ray;
@onready var fireTimer : Timer = $FireRate;

var aim : RayCast3D = null;
var wepSpatial : Vector3 = Vector3.ZERO;

var canFire : bool = true;
var auto : bool = false;

# Recoil
var climb : float = 0.0
var pan : float = 0.0;
var isPanLeft : bool = false;

var parent = null;

func _ready():
	set_process(false);

func _process(delta):
	# Ammo check
	rotation = lerp(rotation, Vector3.ZERO, 0.025);
	global_position = lerp(global_position, wepSpatial, 0.025);
	climb = lerp(climb, 0.0, 0.025);
	pan = 0.0;

func Fire() -> void:
	if(!canFire):
		return;
	canFire = false;
	fireTimer.start();
	if(aim.is_colliding()):
		var target = aim.get_collider();
		if(target == null):
			return;
		if(target.is_in_group("Player") && target.team != parent.team):
			target.TakeDamage(damage);
		elif(target.is_in_group("SageWall")):
			target.get_parent().get_parent().TakeDamage(damage, target);
		elif(target.is_in_group("Environment")):
			var newBulletHole = Visuals.bullet_hole.instantiate();
			target.add_child(newBulletHole);
			newBulletHole.global_position = ray.get_collision_point();
	# Spray
	if(climb < 0.25):
		climb += 0.025;
	else:
		if(pan > 0.1 && !isPanLeft):
			isPanLeft = true;
		elif(pan < -0.1 && isPanLeft):
			isPanLeft = false;
		if(isPanLeft):
			pan -= 0.025;
		else:
			pan += 0.025;
	climb = clamp(climb, 0.0, 0.25);
	#print(climb);
	rotation.x = climb;
	rotation.y = pan;
	aim.get_parent().rotation.x += climb/10;
	anim.play("Fire");

func Equip() -> void:
	pass

func AltFire() -> void:
	pass

func Reload() -> void:
	pass

func _on_fire_rate_timeout():
	canFire = true;
