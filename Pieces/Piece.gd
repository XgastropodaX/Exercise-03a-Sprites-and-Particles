extends Node2D

export (String) var piece
var is_matched
var is_counted
var selected = false
var target_position = Vector2(0,0)

var dying = false

func _ready():
	$Select.texture = $Sprite.texture
	$Select.scale = $Sprite.scale

func _physics_process(_delta):
	if dying:
		queue_free()
	if selected:
		$Select.show()
		$Selected.emitting = true
	else:
		$Select.hide()
		$Selected.emitting = false

func move_piece(change):
	target_position = position + change
	position = target_position

func die():
	dying = true;
