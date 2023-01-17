extends Node

# VFX
@onready var hitVFX = preload("res://VFX/HitEffect.tscn");
@onready var fireVFX = preload("res://VFX/FireEffect.tscn");

# Powerups | Global for easier expansion
@onready var healthPickup = preload("res://Powerups/Health.tscn");
@onready var dShotPickup = preload("res://Powerups/DoubleShot.tscn");
@onready var shieldPickup = preload("res://Powerups/Shield.tscn");
@onready var flatScoreModPickup = preload("res://Powerups/FlatScoreMod.tscn");
@onready var doubleScoreModPickup = preload("res://Powerups/DoubleScoreMod.tscn");

# Abilities
@onready var laser = preload("res://Abilities/Laser.tscn");
