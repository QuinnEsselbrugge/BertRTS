extends Spatial

func _on_ClickPlayer_animation_finished(anim_name):
	queue_free()
