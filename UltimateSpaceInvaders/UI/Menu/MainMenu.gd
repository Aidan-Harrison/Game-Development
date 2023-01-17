extends Control

func _on_start_pressed():
	get_tree().change_scene("res://UI/Menu/PreGame.tscn");

func _on_options_pressed():
	pass

func _on_exit_pressed():
	get_tree().quit();
