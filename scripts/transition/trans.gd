extends Node2D

var size = 32
var half_size = size/2
var ratio = 0.5
var type = 0 # 0-Fadeout; 1-Fadein
var done = false
onready var Square = preload("res://scenes/objects/transition/square.xml")
var squares = []


func _ready():
	var screen_size = Game.WINDOW_DEFAULT
	var rows = ceil(screen_size.x / size)
	var cols = ceil(screen_size.y / size)
	
	for i in range(rows):
		var col = []
		
		for j in range(cols):
			var s = Square.instance()
			s.set_size(0)
			add_child(s)
			col.push_back(s)
			s.set_pos(Vector2(i*size+half_size, j*size+half_size));
		
		squares.push_back(col)
	
	set_fixed_process(true)


func _fixed_process(delta):
	if(!done):
		if(type == 0):
			var cols = squares.size()
			
			for i in range(cols):
				var col = squares[i]
	#			var ratio = ((1.00/cols)*(cols-i)+1)*0.1 #change this last 0.1 to modulate speed
				
				for j in range(col.size()):
					var s = col[j]
					var new_size = s.get_size() - (ratio * delta)
					
					s.set_size(new_size)
		if(type == 0):
			var cols = squares.size()
			
			for i in range(cols):
				var col = squares[i]
	#			var ratio = ((1.00/cols)*(cols-i)+1)*0.1 #change this last 0.1 to modulate speed
				
				for j in range(col.size()):
					var s = col[j]
					var new_size = s.get_size() - ratio
					
					s.set_size(new_size)
	
	if(squares[squares.size()-1][squares[squares.size()-1].size()-1].get_size() < 0.00001 && !done):
		done = true
		print("Transition done!")