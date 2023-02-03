extends CharacterBody2D

@export var SPEED : float = 450.0;
@export var health : int = 5;
@export var maxHealth : int = 5;
var heat : int = 0;
var maxHeat : int = 20;
var baseHealth = health;
var canFire : bool = true;
var canRecharge : bool = false;
@export var upperRechargeThreshold : int = maxHeat * 0.75;
@export var lowerRechargeThreshold : int = maxHeat * 0.75-4;
@export var lives = 1;
@onready var projectile = preload("res://Projectile.tscn");
@onready var heatTimer : Timer = $HeatTimer;
@onready var pText : Label = $PowerupText;
@onready var anim : AnimationPlayer = $AnimationPlayer;

var baseTime : float = 0.8; # Base tick rate for heat value 
var cooldownTime : float = 0.2; # Tick rate for overheat cooldown
var canQuickExit : bool = false; # Used for single input exit on death/victory
var numOfStreams : int = 1; # Single-shot -> Double shot -> ...
var xOffset : float = position.x-25.0; # Used for determining shot position

var shield : int = 0;
var ability = null;

var ui : Control = null;

func _ready():
	print(upperRechargeThreshold);
	print(lowerRechargeThreshold);
	ui = get_parent().get_node("UI").get_node("HUD");
	pText.visible = false;

func _physics_process(delta) -> void:
	var direction : float = Input.get_axis("Left", "Right");
	if(direction):
		velocity.x = direction * SPEED;
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED);
	move_and_slide();

func _input(event) -> void:
	if(Input.is_action_just_pressed("Fire") && canFire):
		xOffset = position.x - 25.0;
		heat+=1;
		if(heat >= maxHeat):
			heat = maxHeat;
			canFire = false;
			heatTimer.wait_time = cooldownTime;
			canRecharge = true;
			ui.heat.modulate = Color.RED;
		ui.heat.value = heat;
		for i in range(0, numOfStreams):
			var newProjectile = projectile.instantiate();
			get_parent().add_child(newProjectile);
			newProjectile.set_as_top_level(true);
			if(numOfStreams == 1): # If single shot, make centred
				newProjectile.position = Vector2(position.x, position.y-50.0);
			else:
				newProjectile.position = Vector2(xOffset, position.y-50.0);
			xOffset += 25.0 * 2;
		var newFireVFX = Preloader.fireVFX.instantiate();
		add_child(newFireVFX);
		newFireVFX.position.y -= 25;
		newFireVFX.emitting = true;
	# Active reload system
	if(Input.is_action_just_pressed("Recharge")):
		print(heat);
		if(heat <= upperRechargeThreshold && heat >= lowerRechargeThreshold && canRecharge):
			heat = 0;
			ui.heat.modulate = Color.WHITE;
	if(Input.is_action_just_pressed("Interact") && canQuickExit):
		get_tree().change_scene_to_file("res://UI/Menu/MainMenu.tscn");
	
	if(Input.is_action_just_pressed("Ability") && ability != null):
		ability.Activate();
	
	if(Input.is_action_just_pressed("Reset")):
		get_tree().reload_current_scene();

func TakeDamage(value : int) -> void:
	shield -= value;
	ui.shield.value = shield;
	if(shield <= 0):
		shield = 0;
		health -= value;
		ui.health.value = health;
		ui.hValue.text = str(health);
		if(health <= 0):
			if(lives <= 0):
				ui.gOver.visible = true;
				ui.anim.play("GameOver");
				canQuickExit = true;
				set_physics_process(false);
				# set_process_input(false);
				visible = false;
				return;
			lives-=1;
			ui.lives.text = str(lives);
			health = baseHealth;
			ui.health.value = health;
			ui.hValue.text = str(health);

func AssignAbility(abi) -> void:
	ability = abi;
	abi.global_position = global_position; # Fix!
	print("Ability: ", abi.global_position, "\nPlayer: ", global_position);
	# Assigns correctly but offsets straight after!

func _on_area_2d_area_entered(area):
	if(area.is_in_group("Powerup")):
		anim.play("Powerup");
		if(area.get_parent().isWorld):
			area.get_parent().Activate(get_parent());
		else:
			area.get_parent().Activate(self);
		area.get_parent().queue_free();

func _on_heat_timer_timeout():
	heat-=1;
	if(heat <= 0):
		heat = 0;
		if(heatTimer.wait_time == cooldownTime):
			canFire = true;
			heatTimer.wait_time = baseTime;
			ui.heat.modulate = Color.WHITE;
		else:
			heatTimer.wait_time = baseTime;
	ui.heat.value = heat;
