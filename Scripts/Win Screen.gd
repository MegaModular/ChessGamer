extends Control

onready var infotransfer = $"/root/Infotransfer"


func _ready():
	$WhiteWins.visible = false
	$BlackWins.visible = false

func _process(delta):
	if infotransfer.black_win == true:
		$WhiteWins.visible = true

	if infotransfer.white_win == true:
		$BlackWins.visible = true
