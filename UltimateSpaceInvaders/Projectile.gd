extends CharacterBody2D

@export var speed : float = 600.0;
@export var damage : int = 1;

func _ready():
	set_as_top_level(true);

func _physics_process(delta):
	position.y -= speed * delta;
	move_and_slide();

func _on_timer_timeout():
	queue_free();

func _on_area_2d_body_entered(body):
	body.TakeDamage(damage);
	var newHitVFX = Preloader.hitVFX.instantiate();
	get_parent().add_child(newHitVFX);
	newHitVFX.set_as_top_level(true);
	newHitVFX.position = position;
	newHitVFX.emitting = true;
	queue_free();
