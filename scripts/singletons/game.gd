# Game Singleton script
# 
# Made as something to access globally to help manage some core elements
# of the game, such as the game configuration or save states.
# I'll prolly let people do whatever they like with it, dunno.
#
# ArcOfDream, 25.08.2016


extends Node

var config = ConfigFile.new() # Config file game can change at the start screen and pause screen
var save = File.new() # Intended for game saves, might just leave it as one slot
var transition = null # Reserved for Transition node to manage transition effects.

# Some default settings for first run
var scale = 1
var fullscreen = false
var maximized = false

# GAME CONSTANTS
const WINDOW_DEFAULT = Vector2(320, 288)
const InputChecker = preload("res://scripts/inputchecker.gd") # Class thing for checking input stuff. Useful!

# GAME FUNCTIONS
func _init():
	# Alright, so I'm going to first check if there's a save file at all.
	# If it fails to find one, I will have the config var create a new one
	# while using the default settings.
	
	var confcode = config.load("user://dicbutt.cfg")
	
	if(confcode == OK):
		scale = config.get_value("screen", "scale", 3)
		fullscreen = config.get_value("screen", "fullscreen", false)
		maximized = config.get_value("screen", "maximized", false)
		print("CONFIG OK!! " + str(scale, fullscreen, maximized))
	else:
		config.set_value("screen", "scale", scale)
		config.set_value("screen", "maximized", maximized)
		config.set_value("screen", "fullscreen", fullscreen)
		confcode = config.save("user://dicbutt.cfg")
		if(confcode == OK):
			print("CONFIG SAVED!!")
		else:
			print("YOU FUCKED UP MIKE!! " + str(confcode))
	
	set_screen_mode()

func _ready():
	pass

func set_screen_mode():
	# I had those first two variables set as initial parameters, though
	# only this method would use them, so here they are.
	# Not sure if that extra checking is worth it though.
	# Maybe I'm paranoid!
	var screen_size = OS.get_screen_size()
	var window_size = WINDOW_DEFAULT * scale
	
	if(!fullscreen && !maximized):
		OS.set_window_fullscreen(false)
		OS.set_window_maximized(false)
		OS.set_window_size(window_size)
		OS.set_window_position( screen_size/2 - window_size/2 )
		
	elif(maximized):
		if(fullscreen):
			OS.set_window_fullscreen(false)
			fullscreen = false
		OS.set_window_maximized(true)
		
	elif(fullscreen):
		if(maximized):
			OS.set_window_maximized(false)
			maximized = false
		OS.set_window_fullscreen(true)


func save_config():
	var confcode
	
	config.set_value("screen", "scale", scale)
	config.set_value("screen", "maximized", maximized)
	config.set_value("screen", "fullscreen", fullscreen)
	confcode = config.save("user://dicbutt.cfg")
	if(confcode == OK):
		print("CONFIG SAVED!!")
	else:
		print("YOU FUCKED UP MIKE!! " + str(confcode))


##EXTRA FUNCTIONS

func smoothstep(from, to, t):
	pass

func smootherstep(from, to, t):
	pass

