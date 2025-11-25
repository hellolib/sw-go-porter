func parseCPUInfoSW64(info []byte) ([]CPUInfo, error) {
	scanner := bufio.NewScanner(bytes.NewReader(info))

	// find the first "processor" line
	firstLine := firstNonEmptyLine(scanner)
	if !strings.HasPrefix(firstLine, "processor") || !strings.Contains(firstLine, ":") {
		return nil, fmt.Errorf("invalid cpuinfo file: %q", firstLine)
	}
	field := strings.SplitN(firstLine, ": ", 2)
	v, err := strconv.ParseUint(field[1], 0, 32)
	if err != nil {
		return nil, err
	}
	firstcpu := CPUInfo{Processor: uint(v)}
	cpuinfo := []CPUInfo{firstcpu}
	i := 0

	for scanner.Scan() {
		line := scanner.Text()
		if !strings.Contains(line, ":") {
			continue
		}
		field := strings.SplitN(line, ": ", 2)
		switch strings.TrimSpace(field[0]) {
		case "processor":
			cpuinfo = append(cpuinfo, CPUInfo{}) // start of the next processor
			i++
			v, err := strconv.ParseUint(field[1], 0, 32)
			if err != nil {
				return nil, err
			}
			cpuinfo[i].Processor = uint(v)
		case "vendor", "vendor_id":
			cpuinfo[i].VendorID = field[1]
		case "cpu family":
			cpuinfo[i].CPUFamily = field[1]
		case "model":
			cpuinfo[i].Model = field[1]
		case "model name":
			cpuinfo[i].ModelName = field[1]
		case "cpu MHz":
			v, err := strconv.ParseFloat(field[1], 64)
			if err != nil {
				return nil, err
			}
			cpuinfo[i].CPUMHz = v
		case "cache size":
			cpuinfo[i].CacheSize = field[1]
		case "physical id":
			cpuinfo[i].PhysicalID = field[1]
		case "flags":
			cpuinfo[i].Flags = strings.Fields(field[1])
		case "bugs":
			cpuinfo[i].Bugs = strings.Fields(field[1])
		case "bogomips":
			v, err := strconv.ParseFloat(field[1], 64)
			if err != nil {
				return nil, err
			}
			cpuinfo[i].BogoMips = v
		case "cache_alignment":
			v, err := strconv.ParseUint(field[1], 0, 32)
			if err != nil {
				return nil, err
			}
			cpuinfo[i].CacheAlignment = uint(v)
		case "address sizes":
			cpuinfo[i].AddressSizes = field[1]
		}
	}
	return cpuinfo, nil
}
