extends KinematicBody2D

#laws of physics
const  GRAVITY = Vector2(0, 1000)

# Movement Constants
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_FRICTION = 20
const MOVEMENT_SPEED = 300
const ACCELERATION = 0.5
const JUMP_FORCE = 300

const SWORD_SCENE = preload("../swordthrow.tscn")
const JUMP_TIME_THRESHOLD = 0.2 # seconds
onready var sprite = get_node("Sprite")
onready var enemy = get_node("../enemy")
onready var timer = get_node("Sprite/Timer")
var anim = "idle"
var fin = false

#player variables
var velocity = Vector2()
var can_attack = true
var can_jump = false
var jump_timer = 0
var hitpoint = 1000
var hpinit = 1000
var collisiondmg = 50
var playergethit = false
var death =false

#start
func _ready():
	set_fixed_process(true)
#process
func _fixed_process(delta):
	velocity += GRAVITY*delta
	# Can jump?
	can_jump = is_move_and_slide_on_floor()
	velocity = move_and_slide(velocity, FLOOR_NORMAL, SLOPE_FRICTION)
	#mouvement
	var mouvement = 0
	#move left
	if (Input.is_action_pressed("ui_left")):
		mouvement -= 1
	if (Input.is_action_pressed("ui_right")):
		mouvement += 1
	#set mouvement speed
	mouvement *= MOVEMENT_SPEED
	#change gorizental velo to the movement
	velocity.x= lerp(velocity.x, mouvement, ACCELERATION)
	if (can_jump && Input.is_action_pressed("ui_up")):
		velocity.y -= JUMP_FORCE
		can_jump = false
	if velocity.x ==0 && can_jump:
		anim = "idle"
	elif !can_jump:
		anim = "jump"
	else : 
		anim = "run"
	if velocity.x > 0 :
		sprite.set_flip_h(false)
	elif velocity.x < 0 :
		sprite.set_flip_h(true)  
	#attack
	if (Input.is_action_pressed("attack")):
		if (sprite.get_frame() == 2):
			anim = "idle"
			can_attack = false
		elif can_attack:
			anim = "attack"
			#sword attack
			if !timer.is_active():
				create_sword()
				restart_timer()
			
	if !Input.is_action_pressed("attack"):
		can_attack = true
	sprite.play(anim)
	
	
	if is_colliding() && !death:
		var collider = get_collider()
		if collider == enemy:
			hitpoint -= collisiondmg
			print(hitpoint)
		
		#player dmged animation
	if hitpoint <=0:
		print('you are dead')
		death = true
		#capture_enemy = true
		autoload.load_scene()
		hitpoint = hpinit
		#player death animation
		#game over

	if death :
		pass

func create_sword():
	var sword = SWORD_SCENE.instance()
	get_parent().add_child(sword)
	if sprite.is_flipped_h()> 0 :
		sword.motion *= -1 
	sword.set_pos(sprite.get_node("Position2D").get_global_pos())

#restart timer func
func restart_timer():
	timer.set_wait_time(.5)
	timer.set_active(true)
	timer.start()

#signal of timer
func _on_Timer_timeout():
	timer.set_active(false)
