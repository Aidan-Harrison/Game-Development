extends Node3D

var aim : RayCast3D = null;
var wepSpatial : Vector3 = Vector3.ZERO;

var auto : bool = false;

var parent = null;

func Fire() -> void:
	print('Knife');

func Equip() -> void:
	$AnimationPlayer.play("Default_Equip");

func AltFire() -> void:
	pass
	
func Reload() -> void:
	pass
