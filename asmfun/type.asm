_ToAsc:
	PHA
	AND #$0F
	JSR .Judge
	STA zLo
	PLA
	LSR
	LSR
	LSR
	LSR
.Judge	CMP #$0A
	BCC .L1
	CLC
	ADC #$37
	RTS
.L1	ADC #$30
	RTS

_ToHex:
	JSR .Judge
	ASL
	ASL
	ASL
	ASL
	PHA
	LDA zLo
	JSR .Judge
	STA zLo
	PLA
	CLC
	ADC zLo
	RTS
.Judge	CMP #$41
	BCS .L1
	SEC
	SBC #$30
	RTS
.L1	SBC #$37
	RTS

_BufStrToHex8:
	LDA sTextBuf+1,X
	STA zLo
	LDA sTextBuf,X
	JSR _ToHex
	RTS

_BufStrToHex16:
	JSR _BufStrToHex8
	PHA
	INX
	INX
	JSR _BufStrToHex8
	STA zLo
	DEX
	DEX
	PLA
	RTS