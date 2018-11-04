extends Control

onready var button = get_node("Button")
var save_scene

func _ready():
	button.connect("toggled", self, "on_toggled") 
	
func on_toggled(pressed):
	if(pressed):
		print("hello")


func _on_Button_pressed():
	#var startgame = load("res://chess.tscn").instance()
	#print(startgame)
	#get_node("/root/ui").add_child(startgame)
	get_tree().change_scene("res://chess.tscn")
	
func save_scene():
	save_scene = get_tree().get_current_scene()
func load_scene():
	if save_scene != null:
		var root = get_tree().get_root()
		var current_scene = get_tree().get_current_scene()
		root.remove_child(current_scene)
		current_scene.queen_free()
		root.add_child(save_scene)
		save_scene = null