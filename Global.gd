extends Node


const SAVE_PATH = "user://savegame.sav"
const SECRET = "C220 Is the Best!"
var save_file = ConfigFile.new()

onready var HUD = get_node_or_null("/root/Level1/UI/HUD")
onready var Coins = get_node_or_null("/Level1/Coins")
onready var Game = load("res://Game.tscn")
onready var Coin = load("res://Level1/Coins.tscn")
onready var Mine = load("res://Mine/Mine.tscn")

var save_data = {
	"general": {
		"score":0
		,"health":100
		,"coins":[]
		,"mines":[]	
	}
}


var VP = Vector2.ZERO
var fade = null
var fade_speed = 0.015

var fade_in = false
var fade_out = ""

var death_zone = 1000





func _ready():
	update_score(0)
	VP = get_viewport().size
	var _signal = get_tree().get_root().connect("size_changed", self, "_resize")
	
func update_score(s):
	save_data["general"]["score"] += s


func _resize():
	VP = get_viewport().size

func _physics_process(_delta):
	if fade == null:
		fade = get_node_or_null("/root/Game/Camera/Fade")
	if fade_out != "":
		execute_fade_out(fade_out)
	if fade_in:
		execute_fade_in()
		

func start_fade_in():
	if fade != null:
		fade.visible = true
		fade.color.a = 1
		fade_in = true

func start_fade_out(target):
	if fade != null:
		fade.color.a = 0
		fade.visible = true
		fade_out = target

func execute_fade_in():
	if fade != null:
		fade.color.a -= fade_speed
		if fade.color.a <= 0:
			fade_in = false

func execute_fade_out(target):
	if fade != null:
		fade.color.a += fade_speed
		if fade.color.a >= 1:
			fade_out = ""
			


func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
		
		
		
		
func restart_level():
	HUD = get_node_or_null("/root/Game/UI/HUD")
	Coins = get_node_or_null("/root/Game/Coins")
	
	for c in Coins.get_children():
		c.queue_free()
	for c in save_data["general"]["coins"]:
		var coin = Coin.instance()
		coin.position = str2var(c)
		Coins.add_child(coin)
	update_score(0)
	get_tree().paused = false

func save_game():
	save_data["general"]["coins"] = []					# creating a list of all the coins and mines that appear in the scene
	save_data["general"]["mines"] = []
	for c in Coins.get_children():
		save_data["general"]["coins"].append(var2str(c.position))	# get a json representation of each of the coins

	var save_game = File.new()						# create a new file object
	save_game.open_encrypted_with_pass(SAVE_PATH, File.WRITE, SECRET)	# prep it for writing to, make sure the contents are encrypted
	save_game.store_string(to_json(save_data))				# convert the data to a json representation and write it to the file
	save_game.close()							# close the file so other processes can read from or write to it
	
func load_game():
	var save_game = File.new()						# Create a new file object
	if not save_game.file_exists(SAVE_PATH):				# If it doesn't exist, skip the rest of the function
		return
	save_game.open_encrypted_with_pass(SAVE_PATH, File.READ, SECRET)	# The file should be encrypted
	var contents = save_game.get_as_text()					# Get the contents of the file
	var result_json = JSON.parse(contents)					# And parse the JSON
	if result_json.error == OK:						# Check to make sure the JSON got successfully parsed
		save_data = result_json.result_json				# If so, load the data from the file into the save_data lists
	else:
		print("Error: ", result_json.error)
	save_game.close()							# Close the file so other processes can read from or write to it
	
	var _scene = get_tree().change_scene_to(Game)				# Load the scene
	call_deferred("restart_level")	
