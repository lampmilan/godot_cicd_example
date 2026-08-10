extends Label


func _ready() -> void:
	text = _build_ver_str()


func _build_ver_str() -> String:
	var major: int = Version.MAJOR
	var minor: int = Version.MINOR
	var patch: int = Version.PATCH
	
	return "%d.%d.%d" % [major, minor, patch]
