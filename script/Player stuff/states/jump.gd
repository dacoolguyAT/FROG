extends state
var jumpspd = 700
var gravity = Player.gravity
var fallgravity = gravity*2
var Max_fall = 5000
func start():
	Player.velocity.y = -jumpspd
func exit():pass
func Update(_delta:float):
	if(Player.is_on_floor()):stateTransition.emit(self, "idle")
	
	Player.velocity.y += get_grav()*_delta
	
	if Input.is_action_just_pressed("P%s_jump"% [Player.playerId]) and Player.dashtime>0:
		stateTransition.emit(self, "dash")
	
	if (Input.is_action_just_released("P%s_jump" % [Player.playerId])&&Player.velocity.y<0):
		Player.velocity.y /= 2
		
func get_grav():
	if Player.velocity.y <0:
		return gravity
	return fallgravity
