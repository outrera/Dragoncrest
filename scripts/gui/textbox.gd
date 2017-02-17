extends ColorFrame
# MICROLOGUE - a small dialog system
# Technically this code should work on any CanvasItem derived node.
# Make sure the font is saved as a resource file when you set it up for loading.

var temp_diag = [
"Hello, world!",
"This is some sort of dialogue!",
"I think I can get it to draw a limited amount of characters if I wanted to.",
"Okay, that is all." ]

var font           = preload("res://assets/misc/font/betterpixel.tres") # The font to be used for drawing text
var portrait       # Texture for the portrait.
var color          = Color(1,1,1) # Color for the text.
var input_dialogue = [] # This is the variable you want to replace for processing dialogues.
var current_string = "" # This should hold the string to iterate over.
var progress       = 0 # value to denote progress of the dialogue array.
var char_pos       = 0 # The amount of characters to process.
var padding        = Vector2(12,12)
var char_amt       = 0 # Amount of characters allowed in a line.
var line_amt       = 0 # Amount of lines allowed in the box
var cutoff         = 48 # Maximum amount of allowed characters before breaking the text.
var delay          = 0.05 # Amount of time before adding to the position.
var time           = 0.0 # General time counter.
var visible        = true # Flag for toggling text visibility.
var continuous     = true # Updates continuously. Consider turning this on for the effects.
var running        = true # Flag for toggling the text processing. Think of it as a pause toggle.
var cut            = false # The flag to tell if to cut the line.
var line_done      = false # The final status of the dialogue iteration over the string.
var finished       = false # A flag set when the dialog is finished in general.

signal dialog_start(dialog) 
signal dialog_continue
signal dialog_end


func _ready():
	# TODO: Set up a proper handler for continuing text
	input_dialogue = temp_diag
	current_string = input_dialogue[progress]
	char_amt = int(floor((get_rect().size.x - padding.x) / 8))
	line_amt = int(floor((get_rect().size.y - padding.y) / 9))
	print(char_amt, " ", line_amt)
	set_fixed_process(true)
	set_process_unhandled_key_input(true) # temporary


func _unhandled_key_input(key_event):
	next_line()


func _draw():
	# This will handle the text drawn on the screen.
	# The idea is that it iterates the current string until it hits the current position, 
	# which updates with the given delay.
	# TODO: Add the modifier stuff here.
	if visible:
		var place = 0
		var character
		var origin = 0
		var pos = Vector2(12, 12)
		var size
		
		while place < char_pos:
			character = current_string.substr(place, 1)
			origin = char_amt * floor(place/char_amt)
			size = font.get_string_size(current_string.substr(origin, place % char_amt))
			pos.x = padding.x + size.x
			pos.y = padding.y + (size.y * floor(place/char_amt))
			
			draw_string(font, pos, character, color)
#			get_node("test").set_text( str(size, ", ", current_string.substr(origin, place % char_amt)))
			place += 1


func _fixed_process(delta):
	# The process function here should be handling time before adding to the position var.
	# TODO: Implement difference between text being cut and text being done.
	
	if running and !finished and !line_done:
		if time >= delay:
			if char_pos < current_string.length():
				char_pos += 1
			else:
				line_done = true
			time = 0
		
		time += delta
		if !continuous:
			update()
	
	if continuous:
		update()


func next_line():
	if line_done:
		progress += 1
		
		if progress < input_dialogue.size() and !finished:
			char_pos = 0
			current_string = input_dialogue[progress]
			line_done = false
			emit_signal("dialog_continue")
		elif progress == input_dialogue.size() and !finished:
			char_pos = 0
			current_string = ""
			input_dialogue = []
			finished = true
			progress = -1
			update()
			emit_signal("dialog_end")
			print("Dialogue finished!")