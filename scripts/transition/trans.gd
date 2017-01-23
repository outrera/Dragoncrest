extends Node2D

var size = 32
var half_size = size/2
var ratio = 0.5
var type = 0 setget set_type, get_type # 0-Fadeout; 1-Fadein
var done = false
onready var Square = preload("res://scenes/objects/transition/square.xml")
var squares = []

signal TRANSITION_START
signal TRANSITION_DONE

func set_type(value):
	type = value

func get_type():
	return type

func on_transition_trigger(value):
	if done:
		type = value
		emit_signal("TRANSITION_START")
		done = false

func _ready():
#	connect("TRANSITION_DONE", Loader, "on_stansition_done")
	Loader.connect("TRANSITION", self, "on_transition_trigger")
	
	var screen_size = Game.WINDOW_DEFAULT
	var rows = ceil(screen_size.x / size)
	var cols = ceil(screen_size.y / size)
	
	for i in range(rows):
		var col = []
		
		for j in range(cols):
#			var a = MeshInstance.new()
			var s = Square.instance()
			s.max_size = half_size
			s.set_size(half_size)
			add_child(s)
			col.push_back(s)
			s.set_pos(Vector2(i*size+half_size, j*size+half_size));
		
		squares.push_back(col)
	
	set_fixed_process(true)

func _fixed_process(delta):
	if(!done):
		if(type == 0): # Cascade Fadeout
			var cols = squares.size()
			
			for i in range(cols):
				var col = squares[i]
				var ratio = ((1.00/cols)*(cols-i)+1)*0.3 #change this last 0.1 to modulate speed
				
				for j in range(col.size()):
					var s = col[j]
					var new_size = s.get_size() - ratio 
					s.set_size(new_size)
				
			if(squares[squares.size()-1][squares[squares.size()-1].size()-1].get_size() < 0.0001):
				done = true
#				print("Transition done!")
				emit_signal("TRANSITION_DONE")
	
		elif(type == 1): # Cascade Fadein
			var cols = squares.size()
			
			for i in range(cols):
				var col = squares[i]
				var ratio = ((1.00/cols)*(cols-i)+1)*0.3 #change this last 0.1 to modulate speed
				
				for j in range(col.size()):
					var s = col[j]
					var new_size = s.get_size() + ratio
					s.set_size(new_size)
				
			if(squares[squares.size()-1][squares[squares.size()-1].size()-1].get_size() >= half_size):
				done = true
#				print("Transition done!")
				emit_signal("TRANSITION_DONE")