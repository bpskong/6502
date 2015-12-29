	.include "define.asm"

	LW zAddr,#$2000
	LW SectSlot,#$0211
	LW SectOffset,#$0E00
	LB LineID,BackAddrID,Flag,#$00
	LB NumPerLine,#$08
	LB sCode,#$80

	JSR _ClrScr
.Disp	JSR _ClrTextBuf
	JSR _PutDat
	JSR _UpDateLCD
	BIT Flag
	BMI .ND
	BVS .DA
	JSR _WaitKey
	LXY #_Func
	SXY zFuncAddr
	JSR _KeyProc
	JMP .Disp
.ND	JSR _WaitKey
	LXY #_NDFunc
	SXY zFuncAddr
	JSR _KeyProc
	JMP .Disp
.DA	JSR _WaitKey
	LXY #_DAFunc
	SXY zFuncAddr
	JSR _KeyProc
	BCC .Disp
	JSR _ReAddr
	JMP .Disp

	.include "type.asm"
	.include "input.asm"
	.include "output.asm"
	.include "disasm.asm"
	.include "control.asm"
