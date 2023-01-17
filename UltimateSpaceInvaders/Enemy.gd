extends CharacterBody2D

@export var SPEED : float = 300.0;
@export var stepDownDistance : float = 150.0;

@export var health : int = 1;
@export var type : int = 1; # Default, tank, missle

var sprite : Texture2D = null;

@onready var proj = preload("res://Projectile.tscn"); 
@onready var parent = null;

#func _physics_process(delta):
	#move_and_slide();
func _ready():
	parent = get_parent();
	match(type):
		1:
			pass
		2:
			pass
		3:
			pass
	
func TakeDamage(damage : int):
	health -= damage;
	if(health <= 0):
		parent.GameState(1);
		if(parent.RowCheck(parent.BOTTOM)):
			parent.BOTTOM-=1;
			print('Bottom: ', parent.BOTTOM);
		if(parent.ColumnCheck(parent.LEFT)):
			parent.LEFT+=1;
			print('Left: ', parent.LEFT);
		if(parent.ColumnCheck(parent.RIGHT)):
			parent.RIGHT-=1;
			print('RIGHT: ', parent.RIGHT);
		queue_free();

func SpawnProjectile():
	var newProj = proj.instantiate();
	get_parent().add_child(newProj);
	newProj.position = Vector2(position.x, position.y+30);
	newProj.speed = -newProj.speed;
