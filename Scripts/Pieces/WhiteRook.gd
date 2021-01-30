extends KinematicBody2D

onready var infotransfer = $"/root/Infotransfer"

var mouse_in_area = false

var direction = Vector2()

var velocity = Vector2()

var type 
var grid

var target_direction = Vector2()

var speed = 0
const MAX_SPEED = 400

signal piece_taken(object)
#$RayCast2D

func _ready():
	infotransfer.white_piece_total += 5
	var castling_check = get_tree().get_root().find_node("WhiteKing", true, false)
	castling_check.connect("castling", self, "handle_castling")
	var piece_taken_check = get_tree().get_root().find_node("SimpleSignals", true, false)
	piece_taken_check.connect("white_piece_taken", self, "piece_taken")
	direction = Vector2()
	self.connect("piece_taken", $"../../SimpleSignals", "white_piece_taken")
	grid = get_parent()
	type = get_parent().PLAYER
	update_areas()
	turn_off_sprites()

func _process(_delta):
	select()
	handle_turns()
 
func _physics_process(delta):
	if Input.is_action_just_pressed("LMB") and infotransfer.selected == self:
		if infotransfer.selected == self and Input.is_action_just_pressed("LMB") and not direction == Vector2():
			if self.is_in_group("rightrook"):
				infotransfer.right_rook_has_moved = true
				print("right rook moved")
			elif self.is_in_group("leftrook"):
				print("left rook moved")
				infotransfer.left_rook_has_moved = true
			var target_pos = grid.update_child_pos(self)
			self.position = target_pos
			$KillCast.force_raycast_update()
			print($KillCast.get_collider())
			if $KillCast.is_colliding():
				emit_signal("piece_taken", $KillCast.get_collider())
			infotransfer.selected = null
			turn_off_sprites()
			$MoveSound.play()
			yield(get_tree().create_timer(0.1), "timeout")
			infotransfer.turn = "black"
			direction = Vector2()
			turn_off_sprites()

func turn_off_sprites():
	for i in $Right.get_children():
		var ye = i.get_children()
		var p = ye[0].get_children()
		p[1].visible = false
	for i in $Left.get_children():
		var ye = i.get_children()
		var p = ye[0].get_children()
		p[1].visible = false
	for i in $Top.get_children():
		var ye = i.get_children()
		var p = ye[0].get_children()
		p[1].visible = false
	for i in $Bottom.get_children():
		var ye = i.get_children()
		var p = ye[0].get_children()
		p[1].visible = false

func handle_castling(eee):
	if self == eee and self.is_in_group("rightrook"):
		direction = Vector2(-2, 0)
		var target_pos = grid.update_child_pos(self)
		self.position = target_pos
	if self == eee and self.is_in_group("leftrook"):
		direction = Vector2(3, 0)
		var target_pos = grid.update_child_pos(self)
		self.position = target_pos

func select():
	if mouse_in_area and Input.is_action_just_pressed("LMB"):
		infotransfer.selected = self
		$Sprite.set_modulate(Color(0.5, 1, 1, 1))
	if not infotransfer.selected == self:
		turn_off_sprites()
		$Sprite.set_modulate(Color(1, 1, 1, 1))

func handle_turns():
	if infotransfer.turn == "white":
		update_areas()
		$Area2D/CollisionShape2D.disabled = false
	else:
		$Area2D/CollisionShape2D.disabled = true
		turn_off_sprites()

var total_collisions_N : int
var total_collisions_E : int ### W/N
var total_collisions_S : int ### S/E
var total_collisions_W : int 

func update_areas():
	if infotransfer.turn == "white" and infotransfer.selected == self:
		for i in $Right.get_children():
			i.force_raycast_update()
			if i.is_colliding():
				if i.get_collider().is_in_group("BlackPiece") and total_collisions_N == 0:
					total_collisions_N += 1
					var xxx = i.get_children()
					var yyy = xxx[0].get_children()
					yyy[0].disabled = false
					yyy[1].visible = true
					#direction = grid.world_to_map(i.get_collision_point()) - grid.world_to_map(Vector2(self.global_position))
				else:
					var xxx = i.get_children()
					var yyy = xxx[0].get_children()
					yyy[0].disabled = true
					yyy[1].visible = false
			else:
				var yee = i.get_children()
				var pee = yee[0].get_children()
				pee[0].disabled = false
				pee[1].visible = true
		total_collisions_N = 0 
		for i in $Bottom.get_children():
			i.force_raycast_update()
			if i.is_colliding():
				if i.get_collider().is_in_group("BlackPiece") and total_collisions_W == 0:
					#direction = grid.world_to_map(i.get_collision_point()) - grid.world_to_map(Vector2(self.global_position))
					var xxx = i.get_children()
					var yyy = xxx[0].get_children()
					yyy[0].disabled = false
					yyy[1].visible = true
					total_collisions_W += 1
				else:
					var xxx = i.get_children()
					var yyy = xxx[0].get_children()
					yyy[0].disabled = true
					yyy[1].visible = false
			else:
				var yee = i.get_children()
				var pee = yee[0].get_children()
				pee[0].disabled = false
				pee[1].visible = true
		total_collisions_W = 0
		
		for i in $Left.get_children():
			i.force_raycast_update()
			if i.is_colliding():
				if i.get_collider().is_in_group("BlackPiece") and total_collisions_E == 0:
					var xxx = i.get_children()
					var yyy = xxx[0].get_children()
					yyy[0].disabled = false
					yyy[1].visible = true
					#direction = grid.world_to_map(i.get_collision_point()) - grid.world_to_map(Vector2(self.global_position))
					total_collisions_E += 1
				else:
					var xxx = i.get_children()
					var yyy = xxx[0].get_children()
					yyy[0].disabled = true
					yyy[1].visible = false
			else:
				var yee = i.get_children()
				var pee = yee[0].get_children()
				pee[0].disabled = false
				pee[1].visible = true
		total_collisions_E = 0
		
		for i in $Top.get_children():
			i.force_raycast_update()
			if i.is_colliding():
				if i.get_collider().is_in_group("BlackPiece") and total_collisions_S == 0:
					var xxx = i.get_children()
					var yyy = xxx[0].get_children()
					yyy[0].disabled = false
					yyy[1].visible = true
					total_collisions_S += 1
				else:
					var xxx = i.get_children()
					var yyy = xxx[0].get_children()
					yyy[0].disabled = true
					yyy[1].visible = false
			else:
				var yee = i.get_children()
				var pee = yee[0].get_children()
				pee[0].disabled = false
				pee[1].visible = true
		total_collisions_S = 0 

func piece_taken(obj):
	if self == obj:
		infotransfer.white_piece_total -= 5
		queue_free()

func _on_Area2D_mouse_entered():
	mouse_in_area = true

func _on_Area2D_mouse_exited():
	mouse_in_area = false

#====Right===#
func _on_Area1_mouse_entered():
	direction = Vector2(1, 0)

func _on_Area2_mouse_entered():
	direction = Vector2(2, 0)

func _on_Area3_mouse_entered():
	direction = Vector2(3, 0)

func _on_Area4_mouse_entered():
	direction = Vector2(4, 0)

func _on_Area5_mouse_entered():
	direction = Vector2(5, 0)

func _on_Area6_mouse_entered():
	direction = Vector2(6, 0)

func _on_Area7_mouse_entered():
	direction = Vector2(7, 0)

func mouse_exited():
	direction = Vector2()

#=====Bottom=====#
func _on_Area11_mouse_entered():
	direction = Vector2(0, 1)

func _on_Area12_mouse_entered():
	direction = Vector2(0, 2)

func _on_Area13_mouse_entered():
	direction = Vector2(0, 3)

func _on_Area14_mouse_entered():
	direction = Vector2(0, 4)

func _on_Area15_mouse_entered():
	direction = Vector2(0, 5)

func _on_Area16_mouse_entered():
	direction = Vector2(0, 6)

func _on_Area17_mouse_entered():
	direction = Vector2(0, 7)

#=====Left=====#
func _on_Area21_mouse_entered():
	direction = Vector2(-1, 0)

func _on_Area22_mouse_entered():
	direction = Vector2(-2, 0)

func _on_Area23_mouse_entered():
	direction = Vector2(-3, 0)

func _on_Area24_mouse_entered():
	direction = Vector2(-4, 0)

func _on_Area25_mouse_entered():
	direction = Vector2(-5, 0)

func _on_Area26_mouse_entered():
	direction = Vector2(-6, 0)

func _on_Area27_mouse_entered():
	direction = Vector2(-7, 0)

#Top
func _on_Area31_mouse_entered():
	direction = Vector2(0, -1)

func _on_Area32_mouse_entered():
	direction = Vector2(0, -2)

func _on_Area33_mouse_entered():
	direction = Vector2(0, -3)

func _on_Area34_mouse_entered():
	direction = Vector2(0, -4)

func _on_Area35_mouse_entered():
	direction = Vector2(0, -5)

func _on_Area36_mouse_entered():
	direction = Vector2(0, -6)

func _on_Area37_mouse_entered():
	direction = Vector2(0, -7)
