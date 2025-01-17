extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_record(value):
	$MaxScoreLabel.text = "Рекорд: " + str(value)
	$MaxScoreLabel.show()

func show_game_over():
	show_message("Вы проиграли")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Моя первая игра!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(0.5).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

func  _ready():
	var file = FileAccess.open("user://game-data.json",FileAccess.READ)
	var content = file.get_as_text()
	show_record(content)
