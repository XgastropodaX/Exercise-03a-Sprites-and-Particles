extends KinematicBody2D


var health = 20
onready var Explosion = load("res://Effects/Explosion.tscn")
var Effects = null

func damage(d):
	health -= d
	if health <= 0:
		Effects = get_node_or_null("/root/Level3/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			Effects.add_child(explosion)
			explosion.global_position = global_position
		var _target = get_tree().change_scene("res://Menu/Win.tscn")
