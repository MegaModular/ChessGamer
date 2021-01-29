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
	update_areas()
	var piece_taken_check = get_tree().get_root().find_node("SimpleSignals", true, false)
	piece_taken_check.connect("black_piece_taken", self, "piece_taken")
	direction = Vector2()
	grid = get_parent()
	type = get_parent().PLAYER
	update_areas()

func _process(_delta):
	select()
	handle_turns()
 
func _physics_process(delta): 
	if Input.is_action_just_pressed("LMB") and infotransfer.selected == self:
		if infotransfer.selected == self and Input.is_action_just_pressed("LMB") and not direction == Vector2():
			var target_pos = grid.update_child_pos(self)
			self.position = target_pos
			$KillCast.force_raycast_update()
			print($KillCast.get_collider())
			if $KillCast.is_colliding():
				emit_signal("piece_taken", $KillCast.get_collider())
			infotransfer.selected = null
			$MoveSound.play()
			yield(get_tree().create_timer(0.1), "timeout")
			infotransfer.turn = "white"
			direction = Vector2()

func select():
	if mouse_in_area and Input.is_action_just_pressed("LMB"):
		infotransfer.selected = self
		$Sprite.set_modulate(Color(0.25, 1, 1, 1))
	if not infotransfer.selected == self:
		$Sprite.set_modulate(Color(1, 1, 1, 1))

func handle_turns():
	if infotransfer.turn == "black":
		update_areas()
		$Area2D/CollisionShape2D.disabled = false
	else:
		$Area2D/CollisionShape2D.disabled = true

func update_areas():
	if infotransfer.turn == "black" and infotransfer.selected == self:
		for i in $RayCasts.get_children():
			if not i.get_collider() == null: 
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
				var xxx = i.get_children()                    
				var yyy = xxx[0].get_children()
				yyy[0].disabled = false
				yyy[1].visible = true
	else:
		for i in $RayCasts.get_children():
			var xxx = i.get_children()
			var yyy = xxx[0].get_children()
			yyy[1].visible = false

func piece_taken(obj):
	if self == obj:
		queue_free()

func _on_Area2D_mouse_entered():
	mouse_in_area = true

func _on_Area2D_mouse_exited():
	mouse_in_area = false


func _on_Area2D1_mouse_entered():
	direction = Vector2(-2, -1)

func _on_Area2D2_mouse_entered():
	direction = Vector2(-2, 1)

func _on_Area2D3_mouse_entered():
	direction = Vector2(-1, 2)

func _on_Area2D4_mouse_entered():
	direction = Vector2(1, 2)

func _on_Area2D5_mouse_entered():
	direction = Vector2(2, 1)

func _on_Area2D6_mouse_entered():
	direction = Vector2(2, -1)

func _on_Area2D7_mouse_entered():
	direction = Vector2(1, -2)

func _on_Area2D8_mouse_entered():
	direction = Vector2(-1, -2)

func mouse_exited():
	direction = Vector2()
