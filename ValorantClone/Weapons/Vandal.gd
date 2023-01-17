extends Node3D;

@export var damage : int = 25;

var isEquipped : bool = false;
var magSize : int = 32;
var ammo : int = magSize;
var totalAmmo : int = magSize*4;
@onready var anim = $AnimationPlayer;
@onready var audio = $AudioStreamPlayer;
@onready var ray = $Ray;

var aim : RayCast3D = null;
var wepSpatial : Vector3 = Vector3.ZERO;

var canFire : bool = true;
var auto : bool = true;

# Recoil
var climb : float = 0.0
var pan : float = 0.0;
var isPanLeft : bool = false;

var parent = null;

# References
@onready var fireTimer : Timer = $FireRate;

func _ready():
	set_process(false);

func _process(delta):
	# Ammo check
	if(ammo <= 0 || totalAmmo <= 0):
		return;
	if(Input.is_action_pressed("Fire") && canFire):
		canFire = false;
		fireTimer.start();
		Fire();
	elif(!Input.is_action_pressed("Fire")):
		rotation = lerp(rotation, Vector3.ZERO, 0.025);
		global_position = lerp(global_position, wepSpatial, 0.025);
		climb = lerp(climb, 0.0, 0.025);
		pan = 0.0;

func Fire() -> void:
	# Ammo
	ammo -=1;
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
	$MeshInstance3d.look_at(ray.get_collision_point());
	#global_position.y += 0.025;
	#global_position.y = clamp(global_position.y, 0.0, 0.1);
	#var change : float = randf_range(-0.1, 0.1);
	anim.play("Fire");
	# audio.playing = true;

func Equip() -> void:
	ray.global_position = aim.global_position;
	#pass

func AltFire() -> void:
	pass

func _on_fire_rate_timeout():
	canFire = true;

func Reload() -> void:
	if(totalAmmo <= 0):
		return;
	# Ammo = current mag
	ammo = magSize;
	totalAmmo -= magSize;
