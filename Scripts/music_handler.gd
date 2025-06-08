extends AudioStreamPlayer

# signal connections will go here! just call get_stream_playback().switch_to_clip_by_name("NAME")

func switch_to_fishing_calm():
	get_stream_playback().switch_to_clip_by_name("fishing-calm")

func switch_to_fishing_bite():
	get_stream_playback().switch_to_clip_by_name("fishing-bite")

func switch_to_restaurant():
	get_stream_playback().switch_to_clip_by_name("restaurant")
