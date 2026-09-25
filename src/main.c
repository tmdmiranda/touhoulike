#include <dos.h>
#include <string.h>
#include <malloc.h>


#define SCAN_ESC   0x01
#define SCAN_W     0x11
#define SCAN_A     0x1E
#define SCAN_S     0x1F
#define SCAN_D     0x20


extern volatile unsigned char keystate[128];
extern void __interrupt __far kb_isr(void);

void (__interrupt __far *old_kb_isr)(void);

void install_keyboard()
{
  old_kb_isr = _dos_getvect(0x09);

  _dos_setvect(0x09, kb_isr);
}

void uninstall_keyboard()
{
  _dos_setvect(0x09, old_kb_isr);
}

void  set_mode(int mode);
void  wait_vblank(void);
void  copy_buffer(unsigned char *buf);


unsigned char *screen_buffer; 

void set_pixel_buffer(int x, int y, unsigned char color)
{
  screen_buffer[y * 320L + x] = color;
}

void clear_buffer(unsigned char color)
{
  memset(screen_buffer, color, 64000);
}


void draw_square(int x, int y, int h, int l, int c)
{
    int row, col;
    for (row = y; row < h + y; row++)
    {
      if (row < 0 || row >= 200)
            continue;
      for (col = x; col < x + l; col++)
      {
        if (col < 0 || col >= 320)
            continue;

        set_pixel_buffer(col, row, c);
      }
    }
}


void  display(void)
{
  draw_square(50, 50, 100, 100, 3);
}

int   main()
{
  int sx = 100, sy = 50;
  int sh= 20, sl = 20;

  screen_buffer = (unsigned char *)malloc(64000);
  if (!screen_buffer)
  {
    return 1;
  }
  install_keyboard();
  set_mode(0x13);

  while(!keystate[SCAN_ESC])
  {
    
    if (keystate[SCAN_D])
    {
      sx += 2;
    }
    if (keystate[SCAN_A])
    {
      sx -= 2;
    }
    if (keystate[SCAN_W])
    {
      sy -= 2;
    }
    if (keystate[SCAN_S])
    {
      sy += 2;
    }
    
    
    
  
    clear_buffer(0);
    display();
    draw_square(sx, sy, sh, sl, 7);
    wait_vblank();
    copy_buffer(screen_buffer);

  }

  set_mode(0x03);
  
  uninstall_keyboard();
  free(screen_buffer);
  return 0;
}

