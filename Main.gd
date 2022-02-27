extends Node

export (PackedScene) var mob_scene = preload("res://Mob.tscn")


func _ready():
	randomize()
	$UI/Retry.hide()


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UI/Retry.visible:
		get_tree().reload_current_scene()


func _on_MobTimer_timeout():
	# Create a Mob instance and add it to the scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()
	
	add_child(mob)	
	mob.connect("squashed", $UI/ScoreLabel, "_on_Mob_squashed")

	if $Player:
		var player_position = $Player.transform.origin
		# We connect the mob to the score label to update the score upon squashing a mob.
		mob.initialize(mob_spawn_location.translation, player_position)
	else:
		_on_Player_hit()


func _on_Player_hit():
	$MobTimer.stop()
	$UI/Retry.show()
