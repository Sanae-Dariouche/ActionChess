extends KinematicBody2D


#laws of physics
const  GRAVITY = Vector2(0, 1000)

# Movement Constants
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_FRICTION = 20
const MOVEMENT_SPEED = 400
const ACCELERATION = 0.5
const JUMP_FORCE = 300
const JUMP_TIME_THRESHOLD = 0.2 # seconds
onready var sprite = get_node("Sprite")
onready var player = get_node("../player")
onready var autoload = get_node("/root/autoload")
var anim = "idle"
var fin = false

#player variables
var death = false
var hitpoint = 100
var can_attack = true
var capture_enemy = false
var velocity = Vector2()
var can_jump = false
var jump_timer = 0
var hpinit = 100

#start
func _ready():
	print(get_index())
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
	if (Input.is_action_pressed("bot_left")):
		mouvement -= 1
	#move right
	if (Input.is_action_pressed("bot_right")):
		mouvement += 1
	#set mouvement speed
	mouvement *= MOVEMENT_SPEED
	#change gorizental velo to the movement
	velocity.x= lerp(velocity.x, mouvement, ACCELERATION)
	if (can_jump && Input.is_action_pressed("bot_up")):
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
	if !Input.is_action_pressed("attack") && !can_attack:
		can_attack = true
	sprite.play(anim)
	#bot
	if player.get_pos().x < get_pos().x:
		if Input.is_action_pressed("bot_right"):
			Input.action_release("bot_right")
		else:
			Input.action_press("bot_left")
	elif player.get_pos().x > get_pos().x:
		if Input.is_action_pressed("bot_left"):
			Input.action_release("bot_left")
		else:
			Input.action_press("bot_right")
	elif player.get_pos().y< 0:
		pass
	#player dmged animation
	if hitpoint <=0:
		print('you are dead')
		capture_enemy = true
		autoload.load_scene()
		hitpoint = hpinit
		#player death animation
		#game over
	#if death :
		
	#	death = false
		

	if is_colliding():
		Input.action_press("bot_attack")
	if sprite.get_frame() == 19:
		Input.action_release("bot_attack")