extends Node2D

@export var mob_scene: PackedScene
var score
var max_score = 0

const path = "user://game-data.json"


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathMusic.play()
	if score > int(max_score):
		save(score)

	
func new_game():
	max_score = load_game()
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Приготовься")
	$HUD.show_record(max_score)
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	if score > int(max_score):
		$HUD.show_record(score)
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func save(content):
	var file = FileAccess.open(path,FileAccess.WRITE)
	if file.open(path, FileAccess.WRITE):
		file.store_string(str(content))
		file.close()
	else:
		print("Не удалось открыть файл для записи.")
	
func load_game():
	var file = FileAccess.open(path,FileAccess.READ)
	var content = file.get_as_text()
	return int(content)
