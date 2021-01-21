extends KinematicBody2D

onready var infotransfer = $"/root/Infotransfer"

var mouse_in_area = false

var direction = Vector2()

var velocity = Vector2()

const UP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const LEFT = Vector2(-1, 0)
const RIGHT = Vector2(1, 0)

var able_to_double_move = true

var type 
var grid

var target_direction = Vector2()

var speed = 0
const MAX_SPEED = 400

signal piece_taken(object)

func _ready():
	var piece_taken_check = get_tree().get_root().find_node("SimpleSignals", true, false)
	piece_taken_check.connect("black_piece_taken", self, "piece_taken")
	direction = Vector2()
	$Move/CollisionShape2D.disabled = true
	$DoubleMove/CollisionShape2D.disabled = true
	$LeftAttackArea/CollisionShape2D.disabled = true
	$RightAttackArea/CollisionShape2D.disabled = true
	grid = get_parent()
	type = get_parent().PLAYER

func handle_black_piece_taken(obj):
	if obj == self:
		infotransfer.white_score += 1
		self.queue_free()

func _process(_delta):
	select()
	#handle_being_selected()
	handle_turns()
	activate_areas()

func _physics_process(delta):
	if Input.is_action_just_pressed("LMB") and able_to_double_move and infotransfer.selected == self:
		if double_move() and direction == Vector2(0, 2):
			able_to_double_move = false
	if check_move() or check_attack():
		if infotransfer.selected == self and Input.is_action_just_pressed("LMB") and not direction == Vector2():
			able_to_double_move = false
			var target_pos = grid.update_child_pos(self)
			self.position = target_pos
			kill_piece()
			infotransfer.selected = null
			infotransfer.turn = "white"
			direction = Vector2()

func check_attack():
	if $LeftAttackRaycast.is_colliding() or $RightAttackRaycast.is_colliding():
		return true
	else:
		return false

func check_move():
	$MoveRaycast.force_raycast_update()
	if $MoveRaycast.is_colliding():
		return false
	else:
		return true

func double_move():
	$DoubleMoveRaycast.force_raycast_update()
	if $DoubleMoveRaycast.is_colliding():
		return false
	else:
		return true

func kill_piece():
	if direction == Vector2(1, 1):
		emit_signal("piece_taken", $RightAttackRaycast.get_collider())
	if direction == Vector2(-1, 1):
		emit_signal("piece_taken", $LeftAttackRaycast.get_collider())

func select():
	if mouse_in_area and Input.is_action_just_pressed("LMB"):
		infotransfer.selected = self
		$Sprite.set_modulate(Color(0.25, 1, 1, 1))
		print(infotransfer.selected)
	if not infotransfer.selected == self:
		$Sprite.set_modulate(Color(1, 1, 1, 1))

func activate_areas():
	if infotransfer.selected == self and infotransfer.turn == "black":
		$RightAttackRaycast.force_raycast_update()
		$LeftAttackRaycast.force_raycast_update()
		$MoveRaycast.force_raycast_update()
		$DoubleMoveRaycast.force_raycast_update()
		if $MoveRaycast.is_colliding():
			$Move/CollisionShape2D.disabled = true
		else:
			$Move/CollisionShape2D.disabled = false
		if $DoubleMoveRaycast.is_colliding():
			$DoubleMove/CollisionShape2D.disabled = true
		elif able_to_double_move:
			$DoubleMove/CollisionShape2D.disabled = false
		if $RightAttackRaycast.is_colliding():
			if $RightAttackRaycast.get_collider().is_in_group("WhitePiece"):
				$RightAttackArea/CollisionShape2D.disabled = false
		else:
			$RightAttackArea/CollisionShape2D.disabled = true
		if $LeftAttackRaycast.is_colliding():
			if $LeftAttackRaycast.get_collider().is_in_group("WhitePiece"):
				$LeftAttackArea/CollisionShape2D.disabled = false
		else:
			$LeftAttackArea/CollisionShape2D.disabled = true
	else:
			$RightAttackArea/CollisionShape2D.disabled = true
			$LeftAttackArea/CollisionShape2D.disabled = true
			$DoubleMove/CollisionShape2D.disabled = true
			$Move/CollisionShape2D.disabled = true

func handle_turns():
	if infotransfer.turn == "black":
		$Area2D/CollisionShape2D.disabled = false
	else:
		$Area2D/CollisionShape2D.disabled = true

func _on_Area2D_mouse_entered():
	mouse_in_area = true

func _on_Area2D_mouse_exited():
	mouse_in_area = false


func _on_Move_mouse_entered():
	direction = Vector2(0, 1)

func mouse_exited():
	direction = Vector2()

func _on_DoubleMove_mouse_entered():
	if able_to_double_move and not $DoubleMoveRaycast.is_colliding():
		direction = Vector2(0, 2)

func _on_LeftAttackArea_mouse_entered():
	if $LeftAttackRaycast.is_colliding() and $LeftAttackRaycast.get_collider().is_in_group("WhitePiece"):
		direction = Vector2(-1, 1)

func _on_RightAttackArea_mouse_entered():
	if $RightAttackRaycast.is_colliding() and $RightAttackRaycast.get_collider().is_in_group("WhitePiece"):
		direction = Vector2(1, 1)

func piece_taken(obj):
	if obj == self:
		queue_free()
