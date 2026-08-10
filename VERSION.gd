class_name Version extends Object


const MAJOR: int = 0
const MINOR: int = 0
const PATCH: int = 0


static func build_ver_str() -> String:
	var major: int = Version.MAJOR
	var minor: int = Version.MINOR
	var patch: int = Version.PATCH
	
	return "%d.%d.%d" % [major, minor, patch]
