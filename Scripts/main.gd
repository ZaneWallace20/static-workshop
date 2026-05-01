extends Control

@onready var grid_request: HTTPRequest = $GridRequest
@onready var lon_lat_request: HTTPRequest = $LonLatRequest
@onready var image: TextureRect = $BG/Inner/Image
@onready var tempature: Label = $BG/Inner/Temperature

@export var lat = 37.718274
@export var lon = -97.286031

@onready var forecast: Label = $BG/Inner/Forecast

var grid_url = "https://api.weather.gov/gridpoints/TOP/%s,%s/forecast"
var lon_lat_url = "https://api.weather.gov/points/%s,%s"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var url = lon_lat_url % [lat, lon]
	
	# first request the GRID SQUARE from cords
	lon_lat_request.request(url)

# request link up
func _on_grid_request_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		return
	
	# convert to dict
	var json_as_text = body.get_string_from_utf8()
	var data = JSON.parse_string(json_as_text)
	
	if data == null:
		return
	
	var current_data = data.get("properties").get("periods").get(0)
	
	# grab data we need
	forecast.text = current_data.get("detailedForecast")
	
	# convert to an int to remove the .0 (sometimes)
	tempature.text = str(int(current_data.get("temperature"))) + "ºF"
	
	var icon_url = current_data.get("icon")

	# we want the large icon image
	icon_url = icon_url.replace("medium", "large")
	
	# tell our image to start request
	image.get_image(icon_url)
	
	
func _on_lon_lat_request_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		return

	# convert to dict
	var json_as_text = body.get_string_from_utf8()
	var data = JSON.parse_string(json_as_text)
	
	if data == null:
		return
		
	# grab the x y for the grid
	var grid_x = data.get("properties").get("gridX")
	var grid_y = data.get("properties").get("gridY")
	
	if grid_x == null or grid_y == null:
		return
	
	# int 
	grid_x = int(grid_x)
	grid_y = int(grid_y)

	var url = grid_url % [grid_x, grid_y]
	
	# request data for the grid we are in
	grid_request.request(url)

# timer runs forever to update live
func _on_timer_timeout() -> void:
	var url = lon_lat_url % [lat, lon]
	lon_lat_request.request(url)
