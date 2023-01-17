extends CharacterBody3D;

@export var SPEED         : float = 400.0;
@export var baseSpeed     : float = SPEED;
@export var walkSpeed     : float = SPEED/2.5;
@export var JUMP_VELOCITY : float = 4.5;
@export var team : int = 0;

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");
var mouse : Vector2 = Vector2.ZERO;
var sensitivity : float = 0.2;
var lockCam : bool = false;

@export var health : int = 100;
@export var armor  : int = 50;
@export var agent  : int = 1;
var skillActive : bool = false;
var dead : bool = false;

# References
@onready var cam        : Camera3D  = $Camera;
@onready var hud        : Control   = $HUD;
@onready var buyMenu    : Control   = $Buy_Menu;
@onready var wepSpatial : Node3D    = $Camera/WeaponSpatial;
@onready var abiSpatial : Node3D    = $Camera/AbilitySpatial;
@onready var aim        : RayCast3D = $Camera/RayCast3d;

var weapon = null;
var weapons = []; # Sidearm -> Primary -> Knife
var activeWep : int = 2; # Default to knife
var abilities = [];
var abilityCharges = [];
var abilityCosts = [];

# Weapon swapping
var lastWep : int = 0;

func _ready() -> void:
	Players.players.append(self);
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	var knife = Preloader.knife.instantiate();
	cam.add_child(knife);
	weapons.append(null);
	weapons.append(null);
	weapons.append(knife);
	AssignWeapon(knife, 2);
	for i in range(0, 4):
		abilities.append(null);
	
	# Abilities
	AgentAssignment.ASSIGN(self, agent);
	for i in abilities:
		if(i != null):
			AgentAssignment.SKILL_TO_AGENT(self, i);

func _physics_process(delta) -> void:
	if(!is_on_floor()):
		velocity.y -= gravity * delta;

	if(Input.is_action_pressed("Jump") && is_on_floor()):
		velocity.y = JUMP_VELOCITY;
	if(Input.is_action_pressed("Walk") && is_on_floor()):
		SPEED = walkSpeed;
	else:
		SPEED = baseSpeed;

	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back");
	var direction = (transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized();
	if(direction):
		velocity.x = direction.x * SPEED * delta;
		velocity.z = direction.z * SPEED * delta;
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED);
		velocity.z = move_toward(velocity.z, 0, SPEED);

	move_and_slide();

func _process(delta) -> void:
	if(!lockCam):
		cam.rotation.x -= mouse.y * sensitivity * delta;
		cam.rotation.x = clamp(cam.rotation.x, -80.0, 80.0); # Fix!
		rotation.y -= mouse.x * sensitivity * delta;
		wepSpatial.position.x += mouse.x * sensitivity * delta / 10.0;
		wepSpatial.position.x = clamp(wepSpatial.position.x, -1.0, 1.0);
		wepSpatial.position.y -= mouse.y * sensitivity * delta / 10.0;
		wepSpatial.position.y = clamp(wepSpatial.position.y, -1.0, 1.0);
	mouse = Vector2.ZERO;
	if(weapons[activeWep] != null):
		weapons[activeWep].wepSpatial = wepSpatial.global_position;

func AssignWeapon(wep, type : int) -> void:
	# weapon = wep;
	wep.parent = self;
	weapons[type] = wep;
	weapons[type].aim = aim;
	wep.global_position = wepSpatial.global_position;

func Swap(activeWeapon : int) -> void:
	if(weapons[activeWeapon] == null):
		return;
	activeWep = activeWeapon;
	for i in range(0, weapons.size()):
		if(i != activeWep && weapons[i] != null):
			weapons[i].visible = false;
			weapons[i].set_process(false);
	weapon = weapons[activeWep];
	weapons[activeWep].visible = true;
	weapons[activeWep].Equip();
	weapons[activeWep].set_process(true);
	#if(weapons[activeWep].auto):
		#return;
	#weapons[activeWep].set_process(false);

func SKILL_ACTIVE_FLIP(isSkill : bool) -> void:
	if(isSkill):
		return;
	if(skillActive):
		skillActive = false;
	else:
		skillActive = true;

func _input(event) -> void:
	if event is InputEventMouseMotion:
		mouse = event.relative;
	# Weapon swapping
	if(Input.is_action_just_pressed("SwapWeapon")):
		lastWep = activeWep;
		var curWep = activeWep;
	elif(Input.is_action_just_pressed("FirstWeapon")):
		Swap(0);
	elif(Input.is_action_just_pressed("SecondWeapon")):
		Swap(1);
	elif(Input.is_action_just_pressed("Knife")):
		Swap(2);
	
	if(Input.is_action_just_pressed("Fire") && !skillActive):
		weapons[activeWep].Fire();
	elif(Input.is_action_just_pressed("AltFire") && !skillActive):
		weapons[activeWep].AltFire();
	
	if(Input.is_action_just_pressed("Reload")):
		weapons[activeWep].Reload();
	
	# Abilities | Fix charges!
	if(Input.is_action_just_pressed("Ability_1")):
		if(abilities[0] != null):
			abilities[0].Activate();
			abilityCharges[0]-=1;
	elif(Input.is_action_just_pressed("Ability_2")):
		if(abilities[1] != null):
			abilities[1].Activate();
			abilityCharges[1]-=1;
	elif(Input.is_action_just_pressed("Ability_3") && !abilityCharges[2]):
		if(abilities[2] != null):
			abilities[2].Activate();
			abilityCharges[2]-=1;
	elif(Input.is_action_just_pressed("Ability_4") && !abilityCharges[3]):
		if(abilities[3] != null):
			abilities[3].Activate();
			abilityCharges[3]-=1;

	if(Input.is_action_just_pressed("Buy")):
		if(buyMenu.visible):
			buyMenu.visible = false;
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
			lockCam = false;
		else:
			buyMenu.visible = true;
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
			lockCam = true;

	if(Input.is_action_just_pressed("Escape")):
		get_tree().quit();
	if(Input.is_action_just_pressed("Reset")):
		get_tree().reload_current_scene();

func Flash() -> void:
	hud.anim.play("Flash");
