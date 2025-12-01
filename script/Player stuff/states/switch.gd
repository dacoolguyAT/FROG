extends state

func start():stateTransition.emit(self, "weapon")
func exit():get_parent().switchWeap()
func Update(_delta:float):pass
