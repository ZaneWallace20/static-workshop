extends TextureRect
@onready var image_request: HTTPRequest = $ImageRequest

# lets us call the icon from here
func get_image(url: String) -> void:
	image_request.request(url)

# request link up
func _on_image_request_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		return
	
	# load the image 
	var img = Image.new()
	if img.load_png_from_buffer(body) == OK:
		
		# if it workes, convert image to a texure
		var img_texture = ImageTexture.new()
		img_texture = ImageTexture.create_from_image(img)
		
		# apply the texture to this texture rect
		self.set_texture(img_texture)
