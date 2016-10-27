extends Node
### Preloading class to detect the state of an Input.
var input_name
var old_state = null
var state = null

#Choose the input to be monitored upon construction.
func _init(var input_name):
	self.input_name = input_name
	print("New InputChecker for " + input_name)

#Update the current/old state, once per input frame.
func update():
	old_state = state
	state = Input.is_action_pressed(input_name)

#Returns true iff the input was just pressed.
func was_just_pressed():
	if(old_state == false and state == true):
		return true
	return false

# Returns true if the input is currently down.
func is_down():
	return state

# Returns true if the input was just released.
func was_just_released():
	if(old_state == true and state == false):
		return true
	return false

#Then I use it in any of my classes which require input checking as follows:
#const InputChecker = preload(res://Util/InputChecker.gd)
#var spacebar = null
#func _ready():
#   spacebar = InputChecker.new(ui_accept)
#func _fixed_process(delta):
#   spacebar.update()
#   if spacebar.was_just_pressed():
#      do_whatever()
#Just dont forget to update() your InputCheckers before checking their state.