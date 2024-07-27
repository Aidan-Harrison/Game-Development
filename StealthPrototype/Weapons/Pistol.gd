extends StaticBody3D;

var damage : float = 35.0;
var ammo   : int   = 10;
var recoil_amount : float = 1.25;

var can_fire : bool = true;
var type : int = Overseer.WEAPON_TYPES.SUB;

# References
@onready var ray          : RayCast3D       = $RayCast3D;
@onready var col          : CollisionShape3D= $CollisionShape3D;
@onready var anim         : AnimationPlayer = $AnimationPlayer;
@onready var muzzle_flash : OmniLight3D     = $MuzzleFlash;
@onready var fire_timer   : Timer           = $FireTimer;
@onready var flash_timer  : Timer           = $FlashTimer;
@onready var ammo_count   : Label3D         = $AmmoCount;

func _ready():
	muzzle_flash.visible = false;
	ammo_count.text = str(ammo);
	# ammo_count.visible = false;

func Fire() -> bool:
	if(ammo <= 0 || !can_fire):
		return false;
	can_fire = false;
	if(ray.is_colliding()):
		var target = ray.get_collider();
		if(target.is_in_group("Damageable")):
			target.TakeDamage(damage);
	anim.play("Fire");
	muzzle_flash.visible = true;
	fire_timer.start();
	flash_timer.start();
	ammo -= 1;
	ammo_count.text = str(ammo);
	return true;

func _on_fire_timer_timeout() -> void:
	can_fire = true;

func _on_flash_timer_timeout() -> void:
	muzzle_flash.visible = false;
