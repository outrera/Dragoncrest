# GAME SCENE MANAGER SCRIPT
# This thing lets me separate stage stuff from the GUI stuff so 
# I don't have to stuff the same GUI node on every single stage.

extends Node

onready var transition = get_node("gui/transition")
onready var shader = get_node("gui/shader")
onready var fps = get_node("gui/fps")
var camera
var player
var current_scene = null

func _init():
	Game.transition = transition
	pass

func _ready():
	Loader.connect("DONE",self,"on_loaded")
	Loader.connect("PROGRESS",self,"on_progress")
	Loader.connect("ERROR",self,"on_error")
#	Loader.slow_down() # this is so the loading process can be seen
	
	Loader.load_scene("res://scenes/menu.tscn", false) # first thing to load

func on_loaded(scene):
	add_child(scene)
	print("Scene Loaded!")

func on_progress(percent):
	pass

func on_error(err):
	print(Loader.show_error(err))
	pass
