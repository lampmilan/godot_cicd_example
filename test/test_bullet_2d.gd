extends GutTest


func test_bullet_moves_forward_based_on_rotation():
	var bullet = autofree(preload("res://bullet_2d.tscn").instantiate())
	bullet.rotation = 0.0
	bullet.position = Vector2.ZERO
	add_child(bullet)

	await wait_physics_frames(1)

	assert_gt(bullet.position.x, 0.0, "Bullet should move along its facing direction")
	assert_eq(bullet.position.y, 0.0, "Bullet at rotation 0 should not move on Y")
	assert_gt(bullet.travelled_distance, 0.0)


func test_bullet_frees_itself_after_exceeding_range():
	var bullet = autofree(preload("res://bullet_2d.tscn").instantiate())
	bullet.travelled_distance = 1201.0
	add_child(bullet)

	await wait_physics_frames(1)

	assert_true(
		not is_instance_valid(bullet) or bullet.is_queued_for_deletion(),
		"Bullet should queue_free once it travels past its range"
	)


func test_bullet_damages_bodies_with_take_damage():
	var bullet = autofree(preload("res://bullet_2d.tscn").instantiate())
	add_child(bullet)

	var target = autofree(CharacterBody2D.new())
	target.set_script(load("res://test/helpers/damageable_stub.gd"))
	add_child(target)

	bullet._on_body_entered(target)

	assert_eq(target.damage_count, 1, "Bullet should call take_damage on hit bodies")
	assert_true(
		not is_instance_valid(bullet) or bullet.is_queued_for_deletion(),
		"Bullet should free itself on impact"
	)


func test_bullet_ignores_bodies_without_take_damage():
	var bullet = autofree(preload("res://bullet_2d.tscn").instantiate())
	add_child(bullet)

	var target = autofree(CharacterBody2D.new())
	add_child(target)

	bullet._on_body_entered(target)

	assert_true(
		not is_instance_valid(bullet) or bullet.is_queued_for_deletion(),
		"Bullet should still free itself when hitting a non-damageable body"
	)
