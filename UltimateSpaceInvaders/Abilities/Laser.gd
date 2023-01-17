extends Node2D

@export var damage : int = 3.0;

@onready var line : Line2D = $Line2d;
@onready var col : CollisionShape2D = $LaserArea/CollisionShape2d;
@onready var holdTimer : Timer = $HoldTimer;
@onready var icon : Sprite2D = $Icon;

var isMax : bool = false;
var canReturn : bool = false;
var maxWidth : float = 100.0;
var minWidth : float = 0.0;

var fallSpeed : float = 300.0;
var taken : bool = false;

func _ready():
	line.width = 0;
	col.scale.x = 0;
	set_physics_process(false);
	Activate();

func _physics_process(delta):
	if(!taken):
		position.y += fallSpeed * delta;
		return;
	if(canReturn):
		line.width = lerp(line.width, 0.0, 0.05);
		col.scale.x = lerp(col.scale.x , 0.0, 0.05);
		if(line.width <= minWidth+1.0):
			set_physics_process(false);
			queue_free();
	else:
		line.width = lerp(line.width, maxWidth, 0.05);
		col.scale.x = lerp(col.scale.x , maxWidth/20, 0.05);
		if(line.width >= maxWidth-5.0 && !isMax):
			holdTimer.start();
			isMax = true;

func Activate() -> void:
	set_physics_process(true);

func _on_hold_timer_timeout():
	canReturn = true;

func _on_area_2d_body_entered(body):
	body.TakeDamage(damage);

func _on_icon_area_body_entered(body):
	if(body.name == "Player"):
		set_physics_process(false);
		taken = true;
		body.AssignAbility(self);
		get_parent().remove_child(self);
		body.add_child(self);
