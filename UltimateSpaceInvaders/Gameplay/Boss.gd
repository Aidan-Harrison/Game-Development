extends CharacterBody2D;

@export var health : int = 50;
@export var SPEED : int = 450;
@export var numOfPhases : int = 1;

@onready var proj = preload("res://Projectile.tscn"); 
var screenWidth = ProjectSettings.get_setting("display/window/size/viewport_width");
var screenHeight = ProjectSettings.get_setting("display/window/size/viewport_height");

var flip : bool = false;
var world = null;

func _ready():
	world = get_parent();
	$Camera2d.set_as_top_level(true);

func _physics_process(delta):
	velocity.x = SPEED;
	if(global_position.x > screenWidth/2):
		global_position.x = screenWidth/2-10;
		SPEED = -SPEED;
		flip = true;
	elif(global_position.x < -screenWidth/2):
		global_position.x = -screenWidth/2+10;
		flip = false;
		SPEED = -SPEED;
	move_and_slide();

func TakeDamage(damage : int) -> void:
	health -= damage;
	world.ui.bossBar.value = health;
	if(health <= 0):
		numOfPhases-=1;
		if(numOfPhases <= 0):
			world.bossLevel = false;
			queue_free();

func Attack() -> void:
	var newProj = null;
	var attack = randi_range(0, 10);
	if(attack < 8):
		newProj = proj.instantiate();
	elif(attack > 8):
		newProj = Preloader.laser.instantiate();
	if(newProj == null):
		return;
	world.add_child(newProj);
	newProj.position = Vector2(position.x, position.y+150);
	if(attack < 8):
		newProj.speed = -newProj.speed;
	else:
		newProj.line.points[1] = Vector2(0, -500); # Fix, Godot's problem
		newProj.rotation = -90;
		newProj.taken = true;
		newProj.Activate();

func _on_attack_timer_timeout():
	Attack();
