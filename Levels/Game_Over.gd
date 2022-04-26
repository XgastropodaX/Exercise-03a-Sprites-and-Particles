extends Control


func _on_Quit_pressed():
	get_tree().quit()


func _on_Replay_pressed():
	get_tree().change_scene("res://Levels/Level1.tscn")
