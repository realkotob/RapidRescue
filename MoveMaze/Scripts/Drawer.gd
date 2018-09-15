extends Node2D


var Palletes = {

	'Vapor' :
		['#050023', '16324f' ,'#9d0a5c','#ea638c','#75d1ff']
	
}

var CURRENT_PALLETE = 'Vapor'

var LINE_WIDTH = 4
var GRID_LINE = 1
var CIRCLE_RADIUS = 7
var GRID_LINES_PER_CELL = 2

var _AA = true

onready var grid_obj = get_parent()
onready var hand_obj = grid_obj.get_node("Hand")

func _process(delta):
	update()

func _draw():
	
	_draw_bg()
	_draw_board_edge()
	_draw_board_paths()
	_draw_injectors()
	_draw_hand()

func _draw_board_edge():
	
	var rect = Rect2(Vector2(), grid_obj.board_size * grid_obj.tile_size)
	var color = Palletes[CURRENT_PALLETE][1]
	var edge_width = GRID_LINE * 2
	draw_line(rect.position, Vector2(rect.size.x, rect.position.y), color, edge_width, _AA)
	draw_line(rect.position, Vector2(rect.position.x, rect.size.y), color, edge_width, _AA)
	draw_line(Vector2(rect.size.x, rect.position.y), rect.size, color, edge_width, _AA)
	draw_line(Vector2(rect.position.x, rect.size.y), rect.size, color, edge_width, _AA)

func _draw_bg():
	var view = get_viewport().size	
	var grid_resolution = (view / grid_obj.board_size) * GRID_LINES_PER_CELL
	
	var relative_pos = self.position - grid_obj.position
	
	# Draw Background
	draw_rect(Rect2(relative_pos, view), Palletes[CURRENT_PALLETE][0],true)
	
	# Draw Grid Lins
	for x in range(1,grid_resolution.x):
		var col_pos = (x * grid_obj.tile_size.x) / GRID_LINES_PER_CELL
		var col_limit = view.y
		draw_line(Vector2(relative_pos.x + col_pos, relative_pos.y), Vector2(col_pos + relative_pos.x, col_limit), Palletes[CURRENT_PALLETE][1], GRID_LINE, _AA)
		
	for y in range(1, grid_resolution.y):
		var row_pos = (y * grid_obj.tile_size.y) / GRID_LINES_PER_CELL
		var row_limit = view.x
		draw_line(Vector2(relative_pos.x, relative_pos.y + row_pos), Vector2(row_limit, relative_pos.y + row_pos), Palletes[CURRENT_PALLETE][1], GRID_LINE, _AA)

func _draw_hand():
	if hand_obj.current_path != null:
		_draw_path_item(hand_obj.current_path, Palletes[CURRENT_PALLETE][4])

func _draw_injectors():
	for injector in grid_obj.injectors:
		var current_color
		if(injector.hot): current_color = Palletes[CURRENT_PALLETE][1]
		else: current_color = Palletes[CURRENT_PALLETE][4]
		
		draw_circle(injector.position, CIRCLE_RADIUS, current_color)
	
func _draw_path_item(item, color):
	
	if item.connections['S']:
		draw_line(
			item.position,
			item.position + Vector2(0, grid_obj.tile_size.y / 2),
			color,
			LINE_WIDTH,
			_AA)
	if item.connections['N']:
		draw_line(
			item.position,
			item.position - Vector2(0, grid_obj.tile_size.y / 2),
			color,
			LINE_WIDTH,
			_AA)
	if item.connections['W']:
		draw_line(
			item.position,
			item.position - Vector2(grid_obj.tile_size.x / 2, 0),
			color,
			LINE_WIDTH,
			_AA)
	if item.connections['E']:
		draw_line(
			item.position,
			item.position + Vector2(grid_obj.tile_size.x / 2, 0),
			color,
			LINE_WIDTH,
			_AA)
		

func _draw_board_paths():
	for item in grid_obj.path_cells:
		var current_color
		if(item.moveable): current_color = Palletes[CURRENT_PALLETE][3]
		else: current_color = Palletes[CURRENT_PALLETE][2]
		
		_draw_path_item(item, current_color)
		