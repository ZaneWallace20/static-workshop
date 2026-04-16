extends Label
func _process(delta):
	var time = Time.get_time_dict_from_system()
	
	var hour = time.hour % 12
	var am_pm = "AM" if time.hour < 12 else "PM"
	if hour == 0:
		hour = 12

	var time_string = "%2d:%02d:%02d" % [hour, time.minute, time.second]
	self.text = time_string + " " + am_pm
