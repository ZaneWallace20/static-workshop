extends TextureRect
@onready var image_request: HTTPRequest = $ImageRequest

func get_image(url: String) -> void:
	image_request.request(url)

func _on_image_request_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		return
	var img = Image.new()
	if img.load_png_from_buffer(body) == OK:
		var img_texture = ImageTexture.new()
		img_texture = ImageTexture.create_from_image(img)
		self.set_texture(img_texture)
