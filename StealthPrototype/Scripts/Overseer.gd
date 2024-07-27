extends Node;

# Master script
# Used for core game functions which need to be global

var world = null; # Current level reference
enum WEAPON_TYPES{MAIN,SUB,EQUIPMENT};

func _ready() -> void:
	pass;

# Takes ones weapon from either the world or another entity and assigns it to another
func AssignWeapon(weapon, entity) -> void:
	weapon.col.disabled = true;
	weapon.get_parent().remove_child(weapon);
	entity.add_child(weapon);
