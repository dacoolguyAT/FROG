extends StateMachine
var ammo = 100000
var ammo2 = 0
var uses = 1
var uses2 =0


var items = { #name, max ammo, uses, *dmg , *speed, reload time, knockback
	"none":["none",0,0,0,0], "pistol": ["pistol",5,2,1,1,1,1],
	 "grenade": ["grenade",1,1,2,1,0,3], "sword":["sword",0,1,3,1,0,-1]
}
var item1 = items["pistol"]
var item2 = items["none"]

func itemGet(Nitem: String):
	if item1 == items["none"]:
		item1 = items[Nitem]
		ammo = item1[1]
		uses = item1[2]
	elif item2 == items["none"]:
		item2 = items[Nitem]
		ammo2 = item2[1]
		uses2 = item2[2]
		
func _ready() -> void: 
	for child in get_children():
		if child is state: 
			states[child.name] = child
			child.stateTransition.connect(changeState)
			child.Player = Player
	if initial_state:
		initial_state.start()
		current = initial_state

func changeState(oldState: state, newStateName: state):
	if oldState.name != current.name:
		print("invalid state change from: "+oldState.name+" but current state is "+current.name)
		return
	var newState = states.get(newStateName)
	if !newState:
		print("new state is empty")
		return
	if current:
		current.end()
	newState.start()
	current = newState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current:
		current.Update(delta)

func reload():
	uses-=1
	ammo = item1[1]

func switchWeap():
	if item2 != items["none"]:
		var temp = item1
		item1 = item2
		item2 = item1
		temp = ammo
		ammo = ammo2
		ammo2 = temp
		temp = uses
		uses = uses2
		uses2 = temp

func kb():Player.knockbackWeap(item1[6])
