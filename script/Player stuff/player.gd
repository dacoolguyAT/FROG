extends CharacterBody2D
class_name player

const CHAIN_PULL = 55
var chain_velocity := Vector2(0,0)
var xAxisRL = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
var yAxisUD = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)

@export var speed = 80
@export var gravity = 980
var fallgravity = gravity*2
var Max_fall = 5000
var max_walk = 500

var dashtime = 1
var dashtimemax = 1

var chain
func _ready() -> void:
	chain = $Chain

var shootvec = Vector2(0,0)
var mouse = false
var deadzone = 1

@export var playerId = 1
var maxhp = 3
var hp = maxhp 


func _process(delta):
	xAxisRL = Input.get_joy_axis(playerId-1, JOY_AXIS_RIGHT_X)
	yAxisUD = Input.get_joy_axis(playerId-1, JOY_AXIS_RIGHT_Y)
	controlerTounge()



func itemGet(Nitem: String):
	$gun_states/weapon.itemGet(Nitem)

func shootWeap(dmg:float, spd:float):
	$bullet.dmg_change(dmg)
	get_tree().get_root().add_child($bullet.shoot(Vector2(0,0).angle_to_point(Vector2(xAxisRL,yAxisUD)),spd,playerId))

func knockbackWeap(gunKb:float):
	velocity = -(Vector2(xAxisRL,yAxisUD).normalized()*gunKb*500) + velocity/(3*gunKb)


func hit():
	hp-=1
	if hp<=0: die()

func die():
	self.queue_free()

func get_grav():
	if velocity.y <0:
		return gravity
	return fallgravity

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.get_button_index()==2:
		if event.pressed:
			mouse = true
			chain.shoot((get_global_mouse_position()-position))
		else:chain.release()


func controlerTounge():
	#controller aiming and shooting
	if abs(xAxisRL) > deadzone || abs(yAxisUD) > deadzone:
		mouse = false
		if Input.is_action_just_pressed("P%s_right_trigger" % [playerId]):
			mouse = false
			chain.shoot(Vector2(xAxisRL, yAxisUD))
	else:chain.flying = false
	if Input.is_action_just_released("P%s_right_trigger" % [playerId]): chain.release()
	
	if mouse: chain.ok(get_global_mouse_position()-position)
	else: 
		chain.ok (Vector2(xAxisRL, yAxisUD))


func _physics_process(delta):
	var walk = (Input.get_action_strength("P%s_right" % [playerId]) - Input.get_action_strength("P%s_left" % [playerId])) * speed
	var updown = (Input.get_action_strength("P%s_up" % [playerId]) - Input.get_action_strength("P%s_down" % [playerId]))
	
	velocity.y = clamp(velocity.y, -Max_fall, Max_fall)
	
	
	if (chain.hooked):
		chain_velocity = to_local(chain.tip).normalized() * CHAIN_PULL
		if sign(updown)!=0 and sign(updown)==sign(chain_velocity.y):
			chain_velocity.y *= 0.55
		elif(sign(updown)!=sign(chain_velocity.y)): chain_velocity.y*=1.55
		if sign(chain_velocity.x) != sign(walk) and sign(walk)!=0:
			chain_velocity.x *= 0.55
		elif(sign(walk)!=sign(chain_velocity.x)): chain_velocity.x*=1.55
	else:
		chain_velocity = Vector2(0,0)
	velocity += chain_velocity
		
	move_and_slide()
	
	velocity.y = clamp(velocity.y, -Max_fall, Max_fall)	# Make sure we are in our limits
	velocity.x = clamp(velocity.x, -Max_fall, Max_fall)
	
	
	var grounded = is_on_floor()
	if grounded:
		dashtime = dashtimemax
		velocity.x *= .9	# Apply friction only on x (we are not moving on y anyway)
		#if velocity.y >= 5:		# Keep the y-velocity small such that
		#	velocity.y = 5		# gravity doesn't make this number huge
	elif is_on_ceiling() and velocity.y <= -5:	# Same on ceilings
		velocity.y = -5
	
	if !grounded:
		velocity.x *= .998
		if velocity.y > 0:
			velocity.y *= .998

func release():
	chain.hooked = false;



	
	
	
