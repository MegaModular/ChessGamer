extends TileMap

var tile_size = get_cell_size()
var half_tile_size = tile_size / 2

enum {PLAYER, OBSTACLE, COLLECTIBLE}

var grid_size = Vector2(8, 8)
var grid = []

#onready var obstacle =  preload("res://Assets/Pieces/WhitePawn.tscn")

func _ready():
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append([null])
	
	#var WhitePawn = get_node("WhitePawn")
	#var start_pos = update_child_pos(Pawn)
	#Pawn.position = start_pos
	
	var positions = []
	for n in range(0):
		var grid_pos = Vector2(randi() % int(grid_size.x), randi() % int(grid_size.y))
		
		if not grid_pos in positions:
			positions.append(grid_pos)
	
	#for pos in positions:
			#var new_obstacle = obstacle.instance()
			#new_obstacle.position = map_to_world(pos) + half_tile_size
			#grid[pos.x][pos.y] = OBSTACLE
			#self.add_child(new_obstacle)
	print(grid)

func is_cell_vacant(pos, direction):
	var grid_pos = world_to_map(pos) + direction
	if grid_pos.x < grid_size.x and grid_pos.x >= 0:
		if grid_pos.y < grid_size.y and grid_pos.y >= 0:
			if grid[grid_pos.x][grid_pos.y] == null:
				print("returning true")
				return true
			else:
				print("returning false")
				return false

func update_child_pos(child_node):
	var grid_pos = world_to_map(child_node.get_position())
	print(grid_pos)
	grid[grid_pos.x][grid_pos.y] = null
	
	var new_grid_pos = grid_pos + child_node.direction
	grid[new_grid_pos.x][new_grid_pos.y] = child_node.type
	
	var target_pos = map_to_world(new_grid_pos) + half_tile_size
	return target_pos
