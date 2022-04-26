extends Area2D


func _on_Exit_body_entered(body):
	if body.name == "Player":
		if name == "Exit_to_2":
			var _target = get_tree().change_scene("res://Levels/Level2.tscn")
		if name == "Exit_to_3":
			var _target = get_tree().change_scene("res://Levels/Level3.tscn")
		if name == "Exit_to_4":
			var _target = get_tree().change_scene("res://Levels/Level4.tscn")
		if name == "Exit_to_5":
			var _target = get_tree().change_scene("res://Levels/Level5.tscn")
		if name == "Exit_to_6":
			var _target = get_tree().change_scene("res://Levels/Level6.tscn")\
			



func _on_FallDeath_body_entered(body):
	var _target = get_tree().change_scene("res://Menu/Death")
