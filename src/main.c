#include <dos.h>
#include <string.h>
#include <malloc.h>

void  set_mode(unsigned char mode);
void  set_pixel(int x, int y, unsigned char color);
void  clear_screen(unsigned char color);
void  key_interrupt(void);
void  wait_vblank(void);
int   check_key(void);
void  copy_buffer(unsigned char __far *buf);


unsigned char __far *screen_buffer; 

void set_pixel_buffer(int x, int y, unsigned char color)
{
  screen_buffer[y * 320L + x] = color;
}

void clear_buffer(unsigned char color)
{
  _fmemset(screen_buffer, color, 64000);
}


void draw_square(int x, int y, int h, int l)
{
    int row, col;
    for (row = y; row < h + y; row++)
    {
      if (row < 0 || row >= 200)
            continue;
      for (col = x; col < x + l; col++)
      {
        if (col < 0 || col >= 200)
            continue;

        set_pixel_buffer(col, row, 3);
      }
    }
}


void  display(void)
{
  draw_square(50, 50, 100, 100);
}

int   main()
{
  int sx, sy = 0;
  int sh, sl = 20;

  screen_buffer = (unsigned char far *)_fmalloc(64000U);
  if (!screen_buffer)
  {
    return 1;
  }

  set_mode(0x13);

  while(1)
  {
    int key = check_key();

    if (key == 27 || key == 'q') 
    {
      break;
    }
    if (key == 'd')
    {
      sx += 1;
    }

  
    clear_buffer(0);
    display();
    draw_square(sx, sy, sh, sl);
    wait_vblank();
    copy_buffer(screen_buffer);

  }

  set_mode(0x03);

  _ffree(screen_buffer);
  return 0;
}

