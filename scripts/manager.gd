extends Node

onready var transition = get_node("gui/transition")
onready var shader = get_node("gui/shader")
onready var fps = get_node("gui/fps")
onready var quit_label = get_node("gui/exit_sign")
onready var quit_button = Game.InputChecker.new("exit") # Let's set up that exit button
onready var debug_intro = Game.InputChecker.new("debug_intro")
var camera
var player
var current_scene = null
var quit_status = 0
#var pxplay = PxPlay.new()

func _ready():
	Loader.connect("DONE",self,"on_loaded")
	Loader.connect("PROGRESS",self,"on_progress")
	Loader.connect("ERROR",self,"on_error")
	Loader.load_scene("res://scenes/intro.tscn", false) # first thing to load
	
	set_process(true)

func _process(delta):
	quit_button.update() # Update state of the exit button
	debug_intro.update()
	
	if debug_intro.was_just_pressed():
		Loader.load_scene("res://scenes/intro.tscn")
	# Probably not the best way to handle it, but this manages the quit process.
	if quit_button.was_just_pressed() and quit_status == 0:
		quit_status += 1*delta
		quit_label.set_opacity(quit_status)
	elif quit_button.is_down() and quit_status > 0 and quit_status < 1:
		quit_status += 1*delta
		quit_label.set_opacity(quit_status)
	elif quit_button.is_down() and quit_status >= 1:
		get_tree().quit()
	elif quit_button.was_just_released():
		quit_status = 0
		quit_label.set_opacity(quit_status)

func on_loaded(scene):
	add_child(scene)
	print("Scene Loaded!")

func on_progress(percent):
	pass

func on_error(err):
	print(Loader.show_error(err))
	pass
