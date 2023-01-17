extends Control;

var numOfAgents : int = 2;
@onready var grid = $Control/Grid;

func _ready():
	grid.columns = numOfAgents;
	for i in numOfAgents:
		var newButton : Button = Button.new();
		grid.add_child(newButton);
		newButton.icon = Preloader.agentIcons[i];

func _on_play_pressed():
	get_tree().change_scene("res://world.tscn");
