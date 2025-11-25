//go:build sw64
// +build sw64

package gomonkey

import "unsafe"

const (
	R25 = 25
	R27 = 27
	R31 = 31
)

const (
	OP_JMP     = 0x03 << 26              // 跳转
	OP_LDL     = 0x23 << 26              // 长字装入
	OP_LDI     = 0x3E << 26              // 立即数装入
	OP_LDIH    = 0x3F << 26              // 立即数装入到高位
	OP_SLL_IMM = 0x12 << 26 | 0x48 << 5  // 逻辑左移 - 立即数格式
)

func buildJmpDirective(double uintptr) []byte {
	res := make([]byte, 0, 28)

	var bits [4]uint32
	for i := range bits {
		bits[i] = uint32(double & 0xFFFF)
		double >>= 16
		if bits[i] & 0x8000 != 0 {
			double += 1
		}
	}

	res = append(res, encodeInstMem(OP_LDIH, R25, R31, bits[3])...)      // ldih r25, bits[3](r31)
	res = append(res, encodeInstMem(OP_LDI, R25, R25, bits[2])...)       // ldi  r25, bits[2](r27)
	res = append(res, encodeInstArith_Imm(OP_SLL_IMM, R25, R25, 32)...)  // sll  r25, 32, r25
	res = append(res, encodeInstMem(OP_LDIH, R25, R25, bits[1])...)      // ldih r25, bits[1](r27)
	res = append(res, encodeInstMem(OP_LDI, R25, R25, bits[0])...)       // ldi  r25, bits[0](r27)
	res = append(res, encodeInstMem(OP_LDL, R27, R25, 0)...)             // ldl  r27, r25
	res = append(res, encodeInstMem(OP_JMP, R31, R27, 0)...)             // jmp  r31, r27

	return res
}

func encodeInstMem(op, ra, rb, disp uint32) []byte {
	var m uint32 = op | (ra & 0x1F) << 21 | (rb & 0x1F) << 16 | (disp & 0xFFFF)
	res := make([]byte, 4)
	*(*uint32)(unsafe.Pointer(&res[0])) = m
	return res
}

func encodeInstArith_Imm(op, ra, rc, imm uint32) []byte {
	var m uint32 = op | (ra & 0x1F) << 21 | (imm & 0xFF) << 13 | (rc & 0x1F)
	res := make([]byte, 4)
	*(*uint32)(unsafe.Pointer(&res[0])) = m
	return res
}
