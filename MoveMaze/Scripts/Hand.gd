extends Node2D

var current_path = null
onready var grid_obj = get_parent()

func _input_event(viewport, event, shape_idx):
	if event.is_pressed():
		rotate_path()
		
	pass

func _ready():
	grid_obj.connect("signal_hand", self, "setup_hand")
	pass

func setup_hand(injectors, path):
	position = Vector2(grid_obj.tile_size.x * (grid_obj.board_size.x + 3), grid_obj.tile_size.y * 3)
	position += grid_obj.half_tile_size
	collect_path(path)
	
	for inj in injectors:
		inj.connect("click_action", self, "place_path")

func collect_path(path):
	if current_path == null:
		current_path = path
		current_path.set_target(position, true)
	else:
		print("CAN ONLY HOLD ONE PATH!")

func place_path(board_index, direction):
	if current_path != null:
		var temp_path = current_path
		current_path = null
		grid_obj.inject_path(board_index, direction, temp_path, funcref(self, 'collect_path'))
	else:
		print("NOTHING TO PLACE!")

func rotate_path():
	var names = current_path.connections.keys()
	var values = current_path.connections.values()
	var temp_values = values.duplicate()
	
	#Shift Bool
	var count = len(names)
	for i in count:
		if i-1 >= 0:
			values[i] = temp_values[i - 1]
		else:
			values[i] = temp_values[count - 1]
			
	# Apply Rotation
	for i in len(current_path.connections):
		current_path.connections[names[i]] = values[i]
		