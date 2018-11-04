#sword.gd
extends Area2D

const SWORD_SPEED = 400
var speed_x = 1
var speed_y = 0 
var motion = Vector2(speed_x, speed_y)*SWORD_SPEED

func _ready():
	set_process(true)
func _process(delta):
	
	set_pos(get_pos() + motion * delta)


func _on_VisibilityNotifier2D_exit_screen():
	print("sdf")
	queue_free()


func _on_Area2D_area_enter( area ):
	queue_free()
	
