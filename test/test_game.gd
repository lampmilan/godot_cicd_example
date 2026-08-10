extends GutTest


var _rooted_game: Node2D


func after_each():
	get_tree().paused = false
	if is_instance_valid(_rooted_game):
		_rooted_game.free()
		_rooted_game = null


func test_spawn_mob_adds_a_mob_child():
	# Mobs resolve the player via absolute path /root/Game/Player.
	_rooted_game = preload("res://survivors_game.tscn").instantiate()
	get_tree().root.add_child(_rooted_game)

	var child_count_before = _rooted_game.get_child_count()
	_rooted_game.spawn_mob()

	assert_eq(_rooted_game.get_child_count(), child_count_before + 1)
	assert_true(_rooted_game.get_children().back().has_method("take_damage"))


func test_player_health_depleted_shows_game_over_and_pauses():
	var game = autofree(preload("res://survivors_game.tscn").instantiate())
	add_child(game)

	var game_over = game.get_node("%GameOver")
	assert_false(game_over.visible, "Game over UI should start hidden")

	game._on_player_health_depleted()

	assert_true(game_over.visible, "Game over UI should appear when the player dies")
	assert_true(get_tree().paused, "Tree should pause on game over")
