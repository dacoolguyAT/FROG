extends state

func start():pass
func exit():pass
func Update(_delta:float):
	if (Input.get_action_strength("P%s_right" % [Player.playerId]) - Input.get_action_strength("P%s_left" % [Player.playerId]))>2:
		stateTransition.emit(self, "walk")
	
