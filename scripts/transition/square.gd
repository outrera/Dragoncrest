extends Node2D
var size = 8 setget set_size, get_size
var color = Color(1,1,1) setget set_color, get_color
var max_size = 0

func set_color(value):
	if typeof(value) == TYPE_COLOR:
		color = value
		update()
	else:
		print("Invalid type! must be a Color!")

func get_color():
	return color

func set_size(value):
	if value < 0:
		size = 0
	elif value > max_size:
		size = max_size
	else:
		size = value
	update()

func get_size():
	return size

func _draw():
	create_square()

func create_square():
	if(size > 0):
	    var points = Vector2Array()
	    points.push_back(Vector2(-size, -size))
	    points.push_back(Vector2(-size,size))
	    points.push_back(Vector2(size,size))
	    points.push_back(Vector2(size,-size))
	    draw_polygon(points,ColorArray([color]))