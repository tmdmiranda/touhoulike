[BITS 32]

segment _TEXT public align=4 class=CODE USE32

global    set_mode_
global    check_key_
global    wait_vblank_
global    copy_buffer_


set_mode_:
  push    ebx
  mov     ah, 0x00
  int     0x10
  pop     ebx
  ret


check_key_:
  mov     ah, 0x01
  int     0x16
  jz      .no_key

  mov     ah, 0x00
  int     0x16
  movzx   eax, al
  ret

.no_key:
  xor     eax, eax
  ret

wait_vblank_:
  mov     edx, 0x03DA

.wait_end:
  in      al, dx
  test    al, 0x08
  jnz     .wait_end

.wait_start:
  in      al, dx
  test    al, 0x08
  jz      .wait_start

  ret

copy_buffer_:
  push    esi
  push    edi

  mov     esi, eax
  mov     edi, 0x000A0000

  mov     ecx, 16000
  cld
  rep     movsd
  
  pop     edi
  pop     esi
  ret
