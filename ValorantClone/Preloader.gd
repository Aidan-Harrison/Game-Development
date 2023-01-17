extends Node

# Agent art
@onready var sageIcon = preload("res://Textures/Agents/Icons/Sage_Icon.png");
var agentIcons = [];

# Agent abilities
# Sage
@onready var sage_wall = preload("res://Agents/Sage/Sage_Wall.tscn");
@onready var sage_orb = preload("res://Agents/Sage/Sage_Orb.tscn");
# Phoenix
@onready var phoenix_flash = preload("res://Agents/Phoenix/Flash.tscn");
@onready var phoenix_wall = preload("res://Agents/Phoenix/PhoenixWall.tscn");

# Weapons
@onready var knife = preload("res://Weapons/Knife.tscn");
@onready var classic = preload("res://Weapons/Classic.tscn");
@onready var vandal = preload("res://Weapons/Vandal.tscn");
@onready var bucky = preload("res://Weapons/Shotguns/Bucky.tscn");

func _ready() -> void:
	for i in 2:
		agentIcons.append(sageIcon);
	LOAD_TO_MEMORY();

func LOAD_TO_MEMORY() -> void:
	pass
