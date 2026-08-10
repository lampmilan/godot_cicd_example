extends GutTest


func test_gun_shoot_spawns_a_bullet():
	var gun = autofree(preload("res://gun.tscn").instantiate())
	add_child(gun)

	var shooting_point = gun.get_node("%ShootingPoint")
	var bullet_count_before = shooting_point.get_child_count()

	gun.shoot()

	assert_eq(
		shooting_point.get_child_count(),
		bullet_count_before + 1,
		"shoot() should add one bullet under the shooting point"
	)
	var spawned = shooting_point.get_children().back()
	assert_not_null(spawned.get_script(), "Spawned child should be a scripted bullet")
	assert_true("travelled_distance" in spawned, "Spawned bullet should track travelled distance")


func test_gun_looks_at_first_enemy_in_range():
	var gun = autofree(preload("res://gun.tscn").instantiate())
	gun.global_position = Vector2.ZERO
	add_child(gun)

	# Overlapping-body aiming needs physics; call look_at the way _process would.
	var enemy = autofree(CharacterBody2D.new())
	enemy.global_position = Vector2(100, 0)
	add_child(enemy)

	gun.look_at(enemy.global_position)

	assert_almost_eq(gun.rotation, 0.0, 0.01, "Gun should face an enemy to the right")
