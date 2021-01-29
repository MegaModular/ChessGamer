extends Control

onready var infotransfer = $"/root/Infotransfer"

func _process(delta):
	if infotransfer.black_win == true:
		$BlackWins.popup()
	else:
		$BlackWins.hide()
	
	if infotransfer.white_win == true:
		$WhiteWins.popup()
	else:
		$WhiteWins.hide()
