extends Label
func _process(delta):
	
	# grab system time
	var time = Time.get_time_dict_from_system()
	
	# convert to 12 hr time
	var hour = time.hour % 12
	var am_pm = "AM" if time.hour < 12 else "PM"
	if hour == 0:
		hour = 12
	
	# string formating to follow x:0y:0z
	var time_string = "%2d:%02d:%02d" % [hour, time.minute, time.second]
	
	# add on the am or pm
	self.text = time_string + " " + am_pm
