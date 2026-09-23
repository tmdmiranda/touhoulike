#include <dos.h>
#include <string.h>
#include <malloc.h>

void  set_mode(int mode);
void  wait_vblank(void);
int   check_key(void);
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
    draw_square(sx, sy, sh, sl, 7);
    wait_vblank();
    copy_buffer(screen_buffer);

  }

  set_mode(0x03);

  free(screen_buffer);
  return 0;
}

