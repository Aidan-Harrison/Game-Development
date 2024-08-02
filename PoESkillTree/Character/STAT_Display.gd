extends Control;

@onready var background  : ColorRect = $ColorRect;

# Core
@onready var SkillPoints : Label = $ColorRect/CoreStats/SKILLPOINTS;
@onready var HealthValue : Label = $ColorRect/CoreStats/HealthContainer/VALUE_Health;
@onready var ManaValue   : Label = $ColorRect/CoreStats/ManaContainer/VALUE_Mana;
@onready var SpeedValue  : Label = $ColorRect/CoreStats/SpeedContainer/VALUE_Speed;
@onready var ShowHide : Button = $Show_Hide;

func _on_show_hide_pressed() -> void:
	if(background.visible):
		background.visible = false;
		ShowHide.position.y = 0;
		ShowHide.text = "V";
	else:
		background.visible = true;
		ShowHide.position.y = 419;
		ShowHide.text = "^";
