extends Control

@onready var grid_request: HTTPRequest = $GridRequest
@onready var lon_lat_request: HTTPRequest = $LonLatRequest
@onready var image: TextureRect = $BG/Inner/Image

@export var lat = 37.718274
@export var lon = -97.286031

@onready var forcast: Label = $BG/Inner/Forcast

var grid_url = "https://api.weather.gov/gridpoints/TOP/%s,%s/forecast"
var lon_lat_url = "https://api.weather.gov/points/%s,%s"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var url = lon_lat_url % [lat, lon]
	lon_lat_request.request(url)



func _on_grid_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		return

	var json_as_text = body.get_string_from_utf8()
	var data = JSON.parse_string(json_as_text)
	
	if data == null:
		return

	forcast.text = data.get("properties").get("periods").get(0).get("detailedForecast")
	var icon = data.get("properties").get("periods").get(0).get("icon")

	icon = icon.replace("medium", "large")
	print(icon)
	image.get_image(icon)
func _on_lon_lat_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		return

	var json_as_text = body.get_string_from_utf8()
	var data = JSON.parse_string(json_as_text)
	
	if data == null:
		return
	var grid_x = data.get("properties").get("gridX")
	var grid_y = data.get("properties").get("gridY")
	
	if grid_x == null or grid_y == null:
		return
	
	grid_x = int(grid_x)
	grid_y = int(grid_y)

	var url = grid_url % [grid_x, grid_y]
	print(url)
	grid_request.request(url)

func _on_timer_timeout() -> void:
	var url = lon_lat_url % [lat, lon]
	lon_lat_request.request(url)
