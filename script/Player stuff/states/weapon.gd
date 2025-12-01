extends state
var deadzone = 1
var Parent = get_parent()

func Update(_delta:float):
	var xAxisRL = Input.get_joy_axis(Player.playerId-1, JOY_AXIS_RIGHT_X)
	var yAxisUD = Input.get_joy_axis(Player.playerId-1, JOY_AXIS_RIGHT_Y)
	
	
	if Parent.item1!=Parent.items["none"]:
		if Parent.uses<=0:
				Parent.item1 = Parent.items["none"]
				if Parent.item2 !=Parent.items["none"]: stateTransition.emit(self, "switch")
		if Parent.ammo<=0:
			stateTransition.emit(self, "reload")
	if Input.is_action_just_pressed("P%s_left_trigger" % [Player.playerId]):
		if abs(xAxisRL) > deadzone || abs(yAxisUD) > deadzone:
			if Parent.item1[0] == "pistol":
				if Parent.ammo>0:
					stateTransition.emit(self, "shootPistol")
					Player.knockbackWeap()
					Parent.ammo-=1
			if Parent.item1[0] == "grenade":
				pass
			if Parent.item1[0] == "sword":
				pass
	if Input.is_action_just_pressed("P%s_left_bumper" % [Player.playerId]): stateTransition.emit(self, "switch")
