# GAME SCENE MANAGER SCRIPT
# This thing lets me separate stage stuff from the GUI stuff so 
# I don't have to stuff the same GUI node on every single stage.

extends Node

var transition
var shader
var fps
var camera
var player
var current_scene
var scene


func _ready():
	transition = get_node("gui/transition")
	shader = get_node("gui/shader")
	fps = get_node("gui/fps")
	pass
