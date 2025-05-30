extends Node

@export var mob_scene: PackedScene
var score = 0

func _ready():  
	$Player.hit.connect(game_over)
	new_game()

func game_over():  
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over() 	
	$Music.stop()
	$DeathSound.play()
	$Player.hide()
	$Player.set_process(false)

func new_game():
	get_tree().call_group("mobs", "queue_free")  # ✅ Reset mobs
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()
	$Player.set_process(true)
	$Player.show()

func _on_score_timer_timeout():
	if $Player.is_moving:  # ✅ Only add score if player is moving
		score += 1
		$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	mob.add_to_group("mobs")  # ✅ Add mob to "mobs" group for cleanup

	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position

	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)
