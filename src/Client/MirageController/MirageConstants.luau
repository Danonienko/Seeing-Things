const MirageConstants = table.freeze({
	TAG = "Mirage",
	MIN_MIRAGE_DISTANCE_ATTRIBUTE = "MinMirageDistance",
	MAX_MIRAGE_DISTANCE_ATTRIBUTE = "MaxMirageDistance",
	MIN_TRANSPARENCY_ATTRIBUTE = "MinTransparency",
	MAX_TRANSPARENCY_ATTRIBUTE = "MaxTransparency",
})

export type MirageConstants = typeof(MirageConstants)

return MirageConstants
