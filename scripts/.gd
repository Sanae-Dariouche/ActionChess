extends Area2D

onready var enemy = get_node("../enemy")

func _ready():
	set_process(true)

func _process(delta):
	pass

func _on_Area2D_body_enter( body ):
	enemy.hitpoint -= 10