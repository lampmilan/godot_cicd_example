extends GutTest


var _game: Node2D
var _player: Node2D


func before_each():
	_game = Node2D.new()
	_game.name = "Game"
	get_tree().root.add_child(_game)

	_player = Node2D.new()
	_player.name = "Player"
	_game.add_child(_player)


func after_each():
	if is_instance_valid(_game):
		_game.free()


func test_mob_starts_with_three_health():
	var mob = autofree(preload("res://mob.tscn").instantiate())
	add_child(mob)

	assert_eq(mob.health, 3)


func test_mob_take_damage_reduces_health():
	var parent = autofree(Node2D.new())
	add_child(parent)

	var mob = preload("res://mob.tscn").instantiate()
	parent.add_child(mob)
	mob.take_damage()

	assert_eq(mob.health, 2)
	assert_true(is_instance_valid(mob), "Mob should stay alive after one hit")


func test_mob_dies_after_three_hits():
	var parent = autofree(Node2D.new())
	add_child(parent)

	var mob = preload("res://mob.tscn").instantiate()
	parent.add_child(mob)

	mob.take_damage()
	mob.take_damage()
	mob.take_damage()

	assert_eq(mob.health, 0)
	assert_true(mob.is_queued_for_deletion(), "Mob should queue_free at zero health")

	await wait_idle_frames(1)

	var smoke_found := false
	for child in parent.get_children():
		if child != mob and child is Node2D:
			smoke_found = true
			break
	assert_true(smoke_found, "Mob should spawn a smoke explosion on death")
