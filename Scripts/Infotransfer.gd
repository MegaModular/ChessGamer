extends Node2D

var selected = null

var king_has_moved : bool = false

var b_king_has_moved : bool = false
var b_right_rook_has_moved : bool = false
var b_left_rook_has_moved : bool = false

var right_rook_has_moved : bool = false
var left_rook_has_moved : bool = false

var turn = "white" # "black"

var white_score = 0
var black_score = 0

var white_win = false
var black_win = false

func _ready():
	pass
