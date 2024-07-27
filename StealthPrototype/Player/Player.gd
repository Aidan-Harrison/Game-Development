extends CharacterBody3D;

# Fundamental
var mouse : Vector2 = Vector2.ZERO;
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity");
@export var mouse_sens   : float = 10.0;

# Physics/Movement
@export var base_speed   : float = 5.0;
@export var crouch_speed : float = base_speed/2;
@export var prone_speed  : float = base_speed/3;
@export var sprint_speed : float = base_speed * 2.25;
@export var acceleration : float = base_speed*1.5;
@export var jump_force   : float = 3.0;
var move_speed           : float = base_speed;
var is_crouched          : bool = false;
var is_proned            : bool = false;

# Weapon/Inventory
var weapons   : Array = [null, null, null];
var inventory : Array = [];
var active_weapon = null;

# Gameplay
@export var health : float = 100.0;
var energy_level   : float = 100.0;
var weight_shift   : float = 4.0;
var weapon_lean_factor : float = weight_shift * 3.5;

# References
@onready var cam                 : Camera3D         = $Camera3D;
@onready var collider            : CollisionShape3D = $Collider;
@onready var hud                                    = $HUD;
@onready var interact_ray        : RayCast3D        = $Camera3D/InteractRay;
@onready var weapon_loc          : Node3D           = $Camera3D/WeaponLocation;
@onready var sub_weapon_holster  : Node3D           = $SubWeaponHolster;
@onready var main_weapon_holster : Node3D           = $MainWeaponHolster;

# Signals
signal disable_cursor(value);

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _physics_process(delta) -> void:
	if(!is_on_floor()):
		velocity.y -= gravity * delta;

	if(Input.is_action_just_pressed("Jump") && is_on_floor()):
		velocity.y = jump_force;

	var input_dir = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward");
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();
	if(direction):
		velocity.x = lerp(velocity.x, direction.x * move_speed, acceleration * delta);
		velocity.z = lerp(velocity.z, direction.z * move_speed, acceleration * delta);
	else:
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta);
		velocity.z = lerp(velocity.z, 0.0, acceleration * delta);
		
	move_and_slide();

func _process(delta) -> void:
	# Camera Movement
	cam.rotation_degrees.x -= mouse.y * mouse_sens * delta;
	cam.rotation_degrees.x = clamp(cam.rotation_degrees.x, -90.0, 90.0);
	rotation_degrees.y -= mouse.x * mouse_sens * delta;
	mouse = Vector2.ZERO;
	
	# Camera and Weapon Lean
	if(Input.is_action_pressed("Move_Left")):
		cam.rotation_degrees.z = lerp(cam.rotation_degrees.z, weight_shift, 6.0 * delta);
		weapon_loc.rotation_degrees.z = lerp(weapon_loc.rotation_degrees.z, weapon_lean_factor, 6.0 * delta);
	if(Input.is_action_pressed("Move_Right")):
		cam.rotation_degrees.z = lerp(cam.rotation_degrees.z, -weight_shift, 6.0 * delta);
		weapon_loc.rotation_degrees.z = lerp(weapon_loc.rotation_degrees.z, -weapon_lean_factor, 6.0 * delta);
	cam.rotation_degrees.z = lerp(cam.rotation_degrees.z, 0.0, 6.0 * delta);
	weapon_loc.rotation_degrees.z = lerp(weapon_loc.rotation_degrees.z, 0.0, 6.0 * delta);
	
	# Movement
	if(Input.is_action_pressed("Sprint")):
		move_speed = sprint_speed;
	
	# Weapon fire
	if(Input.is_action_pressed("Fire") && active_weapon != null):
		if(active_weapon.Fire()):
			cam.rotation_degrees.x += active_weapon.recoil_amount;
	
func _input(event) -> void:
	if(event is InputEventMouseMotion): # Assign mouse input to Vector
		mouse = event.relative;
	# ====== Movement ======
	if(Input.is_action_pressed("Crouch")):
		if(!is_crouched):
			move_speed = crouch_speed;
			collider.shape.height = 0.75;
			is_crouched = true;
		else:
			move_speed = base_speed;
			collider.shape.height = 2.0;
			is_crouched = false;
	if(Input.is_action_just_pressed("Prone")):
		if(!is_proned):
			move_speed = prone_speed;
			collider.shape.height = 0.075;
			is_proned = true;
		else:
			move_speed = base_speed;
			collider.shape.height = 2.0;
			is_proned = false;
	if(Input.is_action_just_released("Sprint")):
		move_speed = base_speed;
	# ====== Interaction   ======
	if(Input.is_action_just_pressed("Interact") && interact_ray.is_colliding()):
		var target = interact_ray.get_collider();
		if(target.is_in_group("Weapon")):
			# Get weapon type | Main or Sub (Secondary)!
			Overseer.AssignWeapon(target, self);
			match(target.type):
				Overseer.WEAPON_TYPES.MAIN:
					weapons[0] = target;
					add_child(target);
					target.global_position = main_weapon_holster.global_position;
				Overseer.WEAPON_TYPES.SUB:
					weapons[1] = target;
					add_child(target);
					target.global_position = sub_weapon_holster.global_position;
		elif(target.is_in_group("Enemy")):
			if(target.can_be_assasinated):
				target.Die();
		elif(target.is_in_group("Activateable")):
			target.get_parent().Activate();
	# ====== Weapon system ======
	if(Input.is_action_just_pressed("Main_Weapon") && weapons[0] != null):
		if(active_weapon == weapons[0]):
			weapon_loc.remove_child(active_weapon);
			add_child(active_weapon);
			active_weapon.global_position = main_weapon_holster.global_position;
			active_weapon = null;
			return;
		elif(active_weapon == weapons[1] && active_weapon != null): # Swap main for sub
			weapon_loc.remove_child(active_weapon);
			add_child(active_weapon);
			active_weapon.global_position = main_weapon_holster.global_position; # Holster main weapon
			active_weapon = weapons[0];
			remove_child(active_weapon); # Remove sub from holster
			weapon_loc.add_child(active_weapon);
			active_weapon.global_position = weapon_loc.global_position;
			return;
		active_weapon = weapons[0];
		remove_child(active_weapon);
		weapon_loc.add_child(active_weapon);
		active_weapon.global_position = weapon_loc.global_position;
	elif(Input.is_action_just_pressed("Sub_Weapon") && weapons[1] != null): # Prvent error on child moving!
		if(active_weapon == weapons[1]): # Hide
			weapon_loc.remove_child(active_weapon);
			add_child(active_weapon);
			active_weapon.global_position = sub_weapon_holster.global_position;
			active_weapon = null;
			return;
		elif(active_weapon == weapons[0] && active_weapon != null): # Swap sub for main
			print("SWAP!");
			weapon_loc.remove_child(active_weapon);
			add_child(active_weapon);
			active_weapon.global_position = sub_weapon_holster.global_position; # Holster sub weapon
			active_weapon = weapons[1];
			remove_child(active_weapon); # Remove main from holster
			weapon_loc.add_child(active_weapon);
			active_weapon.global_position = weapon_loc.global_position;
			return;
		active_weapon = weapons[1];
		remove_child(active_weapon);
		weapon_loc.add_child(active_weapon);
		active_weapon.global_position = weapon_loc.global_position;

func TakeDamage(damage_to_take : float) -> void:
	health -= damage_to_take;
	if(health <= 0):
		Die();

func Die() -> void:
	queue_free();
