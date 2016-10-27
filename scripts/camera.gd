extends Camera2D

var player_found = false
var player
var current_target


func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	
	var zoom = get_zoom()
	var shaderpos = Vector2(-128, -128) * zoom
	
	if(!player_found && Globals.has("player_path")):
		player = get_node(Globals.get("player_path"))
		current_target = player
		print("Found Player path at " + Globals.get("player_path"))
		player_found = true
	
	
	set_pos(current_target.get_pos())
#	shader.set_scale(zoom)
#	shader.set_pos(shaderpos)

func is_target_current(path):
	pass