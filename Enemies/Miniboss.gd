extends KinematicBody2D

var health = 8

var Effects = null
onready var Bullet = load("res://Enemies/Bullet.tscn")
onready var Explosion = load("res://Effects/Explosion.tscn")


func damage(d):
	health -= d
	if health <= 0:
		Effects = get_node_or_null("/root/Level3/Effects")
		if Effects != null:
			var explosion = Explosion.instance()
			Effects.add_child(explosion)
			explosion.global_position = global_position
		queue_free()



func _on_Timer_timeout():
	var Player = get_node_or_null("/root/Level3/Player_Container/Player")
	Effects = get_node_or_null("/root/Level3/Effects")
	if Player != null and Effects != null:
		var bullet = Bullet.instance()
		var d = global_position.angle_to_point(Player.global_position) - PI/2
		bullet.rotation = d
		bullet.global_position = global_position + Vector2(0,-40).rotated(d)
		Effects.add_child(bullet)


