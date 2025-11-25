
// sw_64 changes
func isSW_64() bool {
	arch, err := getMachineArch()
	if err == nil {
		return strings.Contains(arch, "sw_64")
	}
	return false
}
