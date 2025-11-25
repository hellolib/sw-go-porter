
type SchedAttr struct {
	Size     uint32
	Policy   uint32
	Flags    uint64
	Nice     int32
	Priority uint32
	Runtime  uint64
	Deadline uint64
	Period   uint64
	Util_min uint32
	Util_max uint32
}

const SizeofSchedAttr = 0x38
