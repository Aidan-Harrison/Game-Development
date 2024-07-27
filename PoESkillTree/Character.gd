extends Node;

class PoE_Character:
	# Core
	var Name   : String = "Default Character";
	var Health : float = 100.0;
	var Mana   : float = 50.0;
	var MoveSpeed : float = 10.0;
	# Defences
	var Armour : float = 1.0;
	var Block  : float = 1.0;
	var Dodge  : float = 1.0;
	# Resistances
	var FireResistance      : float = 0.0;
	var ColdResistance      : float = 0.0;
	var LightningResistance : float = 0.0;
