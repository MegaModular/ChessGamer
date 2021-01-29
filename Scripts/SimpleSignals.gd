extends Node2D

var black_piece_taken
var white_piece_taken

signal white_piece_taken() 
signal black_piece_taken()

var chance_to_bonk = 0.1
var bonk_rng = 0

func black_piece_taken(object):
	white_piece_taken = object
	emit_signal("white_piece_taken", white_piece_taken)
	bonk_rng = rand_range(0, 1)
	if bonk_rng <= 0.1:
		$Bonk.play()
	else:
		$KillSound.play()

func white_piece_taken(object):
	black_piece_taken = object
	emit_signal("black_piece_taken", black_piece_taken)
	bonk_rng = rand_range(0, 1)
	if bonk_rng <= 0.1:
		$Bonk.play()
	else:
		$KillSound.play()

#====EnPassant====# 
func _on_EnPassantArea_WhitePawn_body_entered(body):
	pass

func _on_EnPassantArea_WhitePawn_body_exited(body):
	pass # Replace with function body.

func _on_EnPassantArea_BlackPawn_body_entered(body):
	pass # Replace with function body.

func _on_EnPassantArea_BlackPawn_body_exited(body):
	pass # Replace with function body.

