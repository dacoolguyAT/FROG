extends state
@export var speed = 80
var max_walk = 500
var playerId = Player.playerId


func start():pass
func exit():pass
func Update(_delta:float):
	
	var walk = Input.get_action_strength("P%s_right" % [playerId]) - Input.get_action_strength("P%s_left" % [playerId])
	
	if(abs(walk)<.1): stateTransition.emit(self,"idle")
	Player.velocity += (walk)*speed*_delta
	Player.move_and_slide()
		
	if Input.is_action_just_pressed("P%s_jump" % [playerId]) && Player.is_on_floor(): stateTransition.emit(self, "jump")
