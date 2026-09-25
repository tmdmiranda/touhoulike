[BITS 32]

segment _DATA public align=4 class=DATA USE32

global _keystate
_keystate times 128 db 0

segment _TEXT public align=4 class=CODE USE32

global kb_isr_


kb_isr_:
  pushad

  xor     eax, eax

  in      al,  0x60 ;hardware port?
  mov     ebx, eax
  and     ebx, 0x7F
  shr     al,  7   ;so basically we read the scancode and we use a bitmask (0x7F is 0111 1111) basically to not explode it and we shift right the 7th bit or smth idk 
  xor     al,  1   ;and then we flip the last bit
  mov     byte [_keystate + ebx], al
  mov     al,  0x20
  out     0x20, al
  popad
  iretd
