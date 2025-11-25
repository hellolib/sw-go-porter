
func InotifyInit() (fd int, err error) {
	return InotifyInit1(0)
}
