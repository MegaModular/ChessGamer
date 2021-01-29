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
signal castling()

func _ready():
	$RightCastleArea/CollisionShape2D.disabled = true
	$LeftCastleArea/CollisionShape2D.disabled = true
	var piece_taken_check = get_tree().get_root().find_node("SimpleSignals", true, false)
	piece_taken_check.connect("black_piece_taken", self, "piece_taken")
	direction = Vector2()
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
			if direction == Vector2(2, 0):
				emit_signal("castling", $RightCastleCast.get_collider())
			if direction == Vector2(-2, 0):
				emit_signal("castling", $LeftCastleCast.get_collider())
			var target_pos = grid.update_child_pos(self)
			self.position = target_pos
			infotransfer.b_king_has_moved = true
			$KillCast.force_raycast_update()
			print($KillCast.get_collider())
			$MoveSound.play()
			if $KillCast.is_colliding():
				emit_signal("piece_taken", $KillCast.get_collider())
			infotransfer.selected = null
			yield(get_tree().create_timer(0.1), "timeout")
			infotransfer.turn = "white"
			direction = Vector2()

func select():
	if mouse_in_area and Input.is_action_just_pressed("LMB"):
		infotransfer.selected = self
		$Sprite.set_modulate(Color(0.25, 1, 1, 1))
	if not infotransfer.selected == self:
		turn_off_sprites()
		$Sprite.set_modulate(Color(1, 1, 1, 1))

func handle_turns():
	if infotransfer.turn == "black":
		update_areas()
		$Area2D/CollisionShape2D.disabled = false
	else:
		turn_off_sprites()
		$Area2D/CollisionShape2D.disabled = true

func update_areas():
	if infotransfer.selected == self:
		for i in $RayCasts.get_children():
			i.force_raycast_update()
			if i.is_colliding():
				if i.get_collider().is_in_group("WhitePiece"):
					var xxx = i.get_children()
					var yyy = xxx[0].get_children()
					yyy[0].disabled = false
					yyy[1].visible = true
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
		if not infotransfer.b_king_has_moved:
			if not infotransfer.b_right_rook_has_moved:
				$RightCastleCast.force_raycast_update()
				if not $RightCastleCast.get_collider() == null:
					if $RightCastleCast.get_collider().is_in_group("Rook") and $RightCastleCast.get_collider().is_in_group("BlackPiece"):
						$RightCastleArea/CollisionShape2D.disabled = false
						$RightCastleArea/Sprite9.visible = true
			elif infotransfer.b_right_rook_has_moved:
				$RightCastleArea/CollisionShape2D.disabled = true
				$RightCastleArea/Sprite9.visible = false
			if not infotransfer.b_left_rook_has_moved:
				$LeftCastleCast.force_raycast_update()
				if $LeftCastleCast.is_colliding():
					if $LeftCastleCast.get_collider().is_in_group("Rook") and $RightCastleCast.get_collider().is_in_group("BlackPiece"):
						$LeftCastleArea/CollisionShape2D.disabled = false
						$LeftCastleArea/Sprite10.visible = true
			elif infotransfer.b_left_rook_has_moved:
				$LeftCastleArea/CollisionShape2D.disabled = true
				$LeftCastleArea/Sprite10.visible = false
		else:
			$RightCastleArea/CollisionShape2D.disabled = true
			$LeftCastleArea/Sprite10.visible = false
			$LeftCastleArea/CollisionShape2D.disabled = true
			$RightCastleArea/Sprite9.visible = false

func turn_off_sprites():
	for i in $RayCasts.get_children():
		var xxx = i.get_children()
		var yyy = xxx[0].get_children()
		yyy[1].visible = false
	$RightCastleArea/Sprite9.visible = false
	$LeftCastleArea/Sprite10.visible = false


func piece_taken(obj):
	if self == obj:
		queue_free()
		infotransfer.white_win = true

func _on_Area2D_mouse_entered():
	mouse_in_area = true

func _on_Area2D_mouse_exited():
	mouse_in_area = false

#====Right===#

func mouse_exited():
	direction = Vector2()

func _on_Area1_mouse_entered():
	direction = Vector2(1, 0)

func _on_Area11_mouse_entered():
	direction = Vector2(0, 1)

func _on_Area21_mouse_entered():
	direction = Vector2(-1, 0)

func _on_Area31_mouse_entered():
	direction = Vector2(0, -1)

func _on_Area41_mouse_entered():
	direction = Vector2(1, -1)

func _on_Area51_mouse_entered():
	direction = Vector2(1, 1)

func _on_Area61_mouse_entered():
	direction = Vector2(-1, 1)

func _on_Area71_mouse_entered():
	direction = Vector2(-1, -1)

func _on_RightCastleArea_mouse_entered():
	direction = Vector2(2, 0)

func _on_LeftCastleArea_mouse_entered():
	direction = Vector2(-2, 0)
