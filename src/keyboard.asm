[BITS 32]

segment _DATA public align=4 class=DATA USE32

keystate_ times 128 db 0

segment _TEXT public align=4 class=TEXT USE32

global kb_isr_


kb_isr:
