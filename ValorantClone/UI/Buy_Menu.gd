extends Control

var player = null;

func _ready() -> void:
	player = get_parent();
	visible = false;

# Sidearms
func _on_classic_pressed():
	print('Classic purchased');
	var newClassic = Preloader.classic.instantiate();
	player.cam.add_child(newClassic);
	player.AssignWeapon(newClassic, 0);
	player.Swap(0);

# Assault
func _on_vandal_pressed():
	print('Vandal purchased');
	var newVandal = Preloader.vandal.instantiate();
	player.cam.add_child(newVandal);
	player.AssignWeapon(newVandal, 1);
	player.Swap(1);

func _on_bucky_pressed():
	print('Bucky purchased');
	var newBucky = Preloader.bucky.instantiate();
	player.cam.add_child(newBucky);
	player.AssignWeapon(newBucky, 1);
	player.Swap(1);
