extends Area2D

onready var enemy = get_node("../enemy")

func _ready():
	set_process(true)

func _process(delta):
	set_pos(enemy.get_pos())

func _on_enemyArea_area_enter( area ):
	print(area.get_type())
	enemy.hitpoint -= 50
	print(enemy.hitpoint)