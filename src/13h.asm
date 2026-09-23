[BITS 16]

segment _TEXT class=CODE

global    set_mode_
global    set_pixel_
global    clear_screen_
global    key_interrupt_
global    check_key_
global    wait_vblank_
global    copy_buffer_


set_mode_:
  mov     ah, 0x00
  int     0x10
  ret

set_pixel_:
  push    es
  push    di

  mov     di, dx
  shl     di, 8
  shl     dx, 6
  add     di, dx
  add     di, ax

  mov     ax, 0xA000
  mov     es, ax

  mov     [es:di], bl

  pop     di
  pop     es
  ret

clear_screen_:
  push    es
  push    di

  mov     cx, 0xA000
  mov     es, cx
  xor     di, di
  mov     cx, 64000
  cld
  rep     stosb
  
  pop     di
  pop     es
  ret

key_interrupt_:
  mov     ah, 0x00
  int     0x16
  ret


check_key_:
  mov     ah, 0x01
  int     0x16
  jz      .no_key

  mov     ah, 0x00
  int     0x16
  mov     ah, 0
  ret

.no_key:
  xor     ax, ax
  ret

wait_vblank_:
  mov     dx, 0x03DA

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
  push    ds
  push    es
  push    si
  push    di

  mov     ds, dx
  mov     si, ax

  mov     ax, 0xA000
  mov     es, ax
  xor     di, di

  mov     cx, 32000
  cld
  rep     movsw

  pop     di
  pop     si
  pop     es
  pop     ds
  ret
