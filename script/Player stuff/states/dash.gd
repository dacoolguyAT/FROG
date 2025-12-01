extends state

var dashSpd= 600
var dashsp = 1
var dashdelay = 1
var playerId = Player.playerId

func start():pass

func exit():
	Player.dashtime-=.2
	dashsp = 1

func Update(_delta:float):
	if Player.is_on_floor():
		stateTransition.emit(self, "idle")
	var dashx =Input.get_action_strength("P%s_right"% [playerId]) - Input.get_action_strength("P%s_left"% [playerId])
	var dashy = Input.get_action_strength("P%s_down"% [playerId]) - Input.get_action_strength("P%s_up"% [playerId])
	if Player.dashtime>0 and(dashx!=0 or dashy!=0):
		dashsp+=.025
		Player.dashtime-=.07
		Player.velocity = Vector2(dashx,dashy).normalized()*dashSpd*dashsp
	else:
		stateTransition.emit(self, "inAir")
	if Input.is_action_just_released("P%s_jump"% [playerId]):
		stateTransition.emit(self, "inAir")
