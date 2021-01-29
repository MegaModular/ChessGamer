extends Node2D

onready var infotransfer = $"/root/Infotransfer"

func _process(_delta):
	if infotransfer.turn == "black":
		$ColorRect.color = Color(0.2, 0.2, 0.2, 1)
	else:
		$ColorRect.color = Color(0.8, 0.8, 0.8, 1)
