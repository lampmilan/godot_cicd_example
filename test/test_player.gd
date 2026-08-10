extends GutTest


func test_player_starts_with_full_health():
	var player = autofree(preload("res://player.tscn").instantiate())
	add_child(player)

	assert_eq(player.health, 100.0)
	assert_eq(player.get_node("%HealthBar").value, 100.0)


func test_player_emits_health_depleted_when_health_reaches_zero():
	var player = autofree(preload("res://player.tscn").instantiate())
	add_child(player)
	watch_signals(player)

	player.health = 0.0
	player.health_depleted.emit()

	assert_signal_emitted(player, "health_depleted")
