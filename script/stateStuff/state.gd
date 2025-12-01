extends Node
class_name state

signal stateTransition
var Player

func _ready() -> void:Player = get_parent().get_parent()

func start():pass
func exit():pass
func Update(_delta:float):pass
