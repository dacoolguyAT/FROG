extends state
var reloadTimer:float = -.1
func start():reloadTimer = get_parent().item1[5]
func exit():pass
func Update(_delta:float):
	reloadTimer-=_delta
	if reloadTimer<=0:
		get_parent().reload()
		stateTransition.emit(self, "weapon")
	if Input.is_action_just_pressed("P%s_left_bumper" % [Player.playerId]): stateTransition.emit(self, "switch")
