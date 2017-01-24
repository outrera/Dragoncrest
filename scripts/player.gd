extends KinematicBody2D

# Player class, based on platformer samples and Dolphin Island 2


# MEMBER CONSTANTS
#const InputChecker = preload("res://scripts/inputchecker.gd")
const GRAVITY = 550.0 # Pixels/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE  = 40
const WALK_FORCE             = 300
const WALK_MIN_SPEED         = 10
const WALK_MAX_SPEED         = 100
const WALK_MAX_SPEED_RUNNING = 150
const STOP_FORCE             = 600
const JUMP_SPEED             = 200
const JUMP_MAX_AIRBORNE_TIME = 0.2
const SLIDE_STOP_VELOCITY    = 1.0 # One pixel per second
const SLIDE_STOP_MIN_TRAVEL  = 1.0 # One pixel


# MEMBER VARIABLES
var walk_left   = Game.InputChecker.new("move_left")
var walk_right  = Game.InputChecker.new("move_right")
var jump        = Game.InputChecker.new("jump")
var velocity    = Vector2()
var on_air_time = 0
var underwater  = false
var jumping     = false
var attacking   = false
var hurt        = false
var disabled    = false


func _fixed_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
	walk_left.update()
	walk_right.update()
	jump.update()
#	var walk_left = Input.is_action_pressed("move_left")
#	var walk_right = Input.is_action_pressed("move_right")
#	var jump = Input.is_action_pressed("jump")
	
	if(!underwater):
		var stop = true
		var sprite = get_node("sprite")
		
		if (walk_left.is_down()):
			if (velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED):
				force.x -= WALK_FORCE
				stop = false
				sprite.set_flip_h(true)
		elif (walk_right.is_down()):
			if (velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED):
				force.x += WALK_FORCE
				stop = false
				sprite.set_flip_h(false)
		
		if (stop):
			var vsign = sign(velocity.x)
			var vlen = abs(velocity.x)
			
			vlen -= STOP_FORCE*delta
			if (vlen < 0):
				vlen = 0
			
			velocity.x = vlen*vsign
		
		# Integrate forces to velocity
		velocity += force*delta
		
		# Integrate velocity into motion and move
		var motion = velocity*delta
		
		# Move and consume motion
		motion = move(motion)
		
		var floor_velocity = Vector2()
		
		if (is_colliding()):
			# You can check which tile was collision against with this
			# print(get_collider_metadata())
			
			# Ran against something, is it the floor? Get normal
			var n = get_collision_normal()
			
			if (rad2deg(acos(n.dot(Vector2(0, -1)))) < FLOOR_ANGLE_TOLERANCE):
				# If angle to the "up" vectors is < angle tolerance
				# char is on floor
				on_air_time = 0
				floor_velocity = get_collider_velocity()
			
			if (on_air_time == 0 and force.x == 0 and get_travel().length() < SLIDE_STOP_MIN_TRAVEL and abs(velocity.x) < SLIDE_STOP_VELOCITY and get_collider_velocity() == Vector2()):
				# Since this formula will always slide the character around, 
				# a special case must be considered to to stop it from moving 
				# if standing on an inclined floor. Conditions are:
				# 1) Standing on floor (on_air_time == 0)
				# 2) Did not move more than one pixel (get_travel().length() < SLIDE_STOP_MIN_TRAVEL)
				# 3) Not moving horizontally (abs(velocity.x) < SLIDE_STOP_VELOCITY)
				# 4) Collider is not moving
				
				revert_motion()
				velocity.y = 0.0
			else:
				# For every other case of motion, our motion was interrupted.
				# Try to complete the motion by "sliding" by the normal
				motion = n.slide(motion)
				velocity = n.slide(velocity)
				# Then move again
				move(motion)
		
		if (floor_velocity != Vector2()):
			# If floor moves, move with floor
			move(floor_velocity*delta)
		
		if (jumping && velocity.y > 0):
			# If falling, no longer jumping
			jumping = false
		
		if( velocity.y < 0 && !jump.is_down() ):
			velocity.y += -velocity.y/8
		
	#	if (!jump && jumping):
	#		jumping = false
		
		if (on_air_time < JUMP_MAX_AIRBORNE_TIME and jump.was_just_pressed() and !jumping):
			# Jump must also be allowed to happen if the character left the floor a little bit ago.
			# Makes controls more snappy.
			velocity.y = -JUMP_SPEED
			jumping = true
		
		on_air_time += delta

func _ready():
	if(is_inside_tree()):
		Globals.set("player_path", get_path())
		print(Globals.get("player_path"))
	set_fixed_process(true)


func _on_area_body_enter( body ):
	print("Body Thonk from " + body.get_type())
	if(body.has_method("is_in_group")):
		if(body.is_in_group("enemy")):
			print("Collided with enemy!")
		elif(body.is_in_group("projectile")):
			print("Collided with projectile!")
		elif(body.is_in_group("map")):
			print("Why is it colliding with the map?!")