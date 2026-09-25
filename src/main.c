#include <dos.h>
#include <string.h>
#include <malloc.h>

//---keycode defs-----

#define SCAN_ESC   0x01
#define SCAN_W     0x11
#define SCAN_A     0x1E
#define SCAN_S     0x1F
#define SCAN_D     0x20
#define SCAN_SPACE 0x39

//--------------------

#define MAX_BULLETS 32

extern volatile unsigned char keystate[128];
extern void __interrupt __far kb_isr(void);

typedef struct {
  int active;
  int x, y;
  int dx, dy;
  int w, h;
  unsigned char color;
} Entity;

// ---------------------------------------

unsigned char *screen_buffer; 

Entity bullets[MAX_BULLETS];

void (__interrupt __far *old_kb_isr)(void);
void  set_mode(int mode);
void  wait_vblank(void);
void  copy_buffer(unsigned char *buf);

void install_keyboard()
{
  old_kb_isr = _dos_getvect(0x09);

  _dos_setvect(0x09, kb_isr);
}

void uninstall_keyboard()
{
  _dos_setvect(0x09, old_kb_isr);
}

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

void init_bullets(void){
  int i;
  for (i = 0; i < MAX_BULLETS; i++)
  {
    bullets[i].active = 0;
  }
}

void spawn_bullets(int x, int y, int dx, int dy){
  int i;
  for(i = 0; i < MAX_BULLETS; i++)
  {
    if(!bullets[i].active)
    {
      bullets[i].active = 1;
      bullets[i].x = x;
      bullets[i].y = y;
      bullets[i].dx = dx;
      bullets[i].dy = dy;
      bullets[i].w = 2;
      bullets[i].h = 2;
      bullets[i].color = 14;
      return;
    }
  }
}

void update_bullets(void)
{
  int i;
  for (i=0;i<MAX_BULLETS;i++)
    {
      if(bullets[i].active)
      {
        bullets[i].x += bullets[i].dx;
        bullets[i].y += bullets[i].dy;

        if (bullets[i].x < 0 || bullets[i].x >= 320 || bullets[i].y < 0 || bullets[i].y >= 200)
        {
          bullets[i].active = 0;
          continue;
        }
        draw_square(bullets[i].x, bullets[i].y, bullets[i].h, bullets[i].w, bullets[i].color);
      }
    }
}


void handle_input()
{
}


void  display(void)
{
}

int main()
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

    if (keystate[SCAN_SPACE])
    {
      spawn_bullets(sx + (sl / 2), sy + (sh/2), 0, -3);
    }
    
  
    clear_buffer(0);
    draw_square(sx, sy, sh, sl, 7);
    update_bullets();
    wait_vblank();
    copy_buffer(screen_buffer);

  }

  set_mode(0x03);
  
  uninstall_keyboard();
  free(screen_buffer);
  return 0;
}

