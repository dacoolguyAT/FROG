extends Node2D


func _ready() -> void:
	pass # Replace with function body.

@onready var links = $Links		# A slightly easier reference to the links
var direction := Vector2(0,0)	# The direction in which the chain was shot
var tip := Vector2(0,0)			# The global position the tip should be in
								# We use an extra var for this, because the chain is 
								# connected to the player and thus all .position
								# properties would get messed with when the player
								# moves.
var maxspeed = 60
var SPEED = maxspeed	# The speed with which the chain moves
var tipmax = 280
var delay = 1;
var tip_loc = to_local(tip)

var flying = false	# Whether the chain is moving through the air
var hooked = false	# Whether the chain has connected to a wall	

# shoot() shoots the chain in a given direction
func shoot(dir: Vector2) -> void:
	delay = 1;
	#direction = (dir).normalized()	# Normalize the direction and save it
	flying = true					# Keep track of our current scan
	tip = self.global_position		# reset the tip position to the player's position
	$Tip.global_position = tip

func ok(dir:Vector2) ->void:
	direction = ((dir.normalized()*tipmax)-to_local(tip)).normalized()
	

# release() the chain
func release() -> void:
	flying = false	# Not flying anymore	
	hooked = false	# Not attached anymore

# Every graphics frame we update the visuals
func _process(_delta: float) -> void:
	delay-=1
	self.visible = flying or hooked	# Only visible if flying or attached to something
	if not self.visible:
		return	# Not visible -> nothing to draw
	tip_loc = to_local(tip)	# Easier to work in local coordinates
	# We rotate the links (= chain) and the tip to fit on the line between self.position (= origin = player.position) and the tip
	links.rotation = self.position.angle_to_point(tip_loc) - deg_to_rad(90)
	$Tip.rotation = self.position.angle_to_point(tip_loc) - deg_to_rad(90)
	links.position = Vector2(0,0).lerp(tip_loc,.5)						# The links are moved to start at the tip
	links.region_rect.size.y = tip_loc.length()		# and get extended for the distance between (0,0) and the tip

# Every physics frame we update the tip position
func _physics_process(_delta: float) -> void:
	var tip_loc = to_local(tip)
	if tip_loc.length()>tipmax+150:
		release()
	$Tip.global_position = tip	# The player might have moved and thus updated the position of the tip -> reset it
	if flying:
		# `if move_and_collide()` always moves, but returns true if we did collide
		#AAAAAAAAAAHHHHHHHHHHHHHH SPEED = clamp(((direction*tipmax).distance_to($Tip.position))*SPEED,(0),maxspeed)
		if $Tip.move_and_collide(direction* SPEED) && delay<0:
			hooked = true	# Got something!
			flying = false	# Not flying anymore
			
	tip = $Tip.global_position	# set `tip` as starting position for next frame
