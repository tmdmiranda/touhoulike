#include <SDL3/SDL.h>
#include <iostream>

const int WINDOW_WIDTH = 800;
const int WINDOW_HEIGHT = 600;

int main(int argc, char* argv[]) {
    // Initialize SDL
    if (!SDL_Init(SDL_INIT_VIDEO)) {
        std::cerr << "SDL_Init failed: " << SDL_GetError() << std::endl;
        return 1;
    }

    // Create window
    SDL_Window* window = SDL_CreateWindow(
        "SDL3 Cross-Platform Game",
        WINDOW_WIDTH, WINDOW_HEIGHT,
        SDL_WINDOW_RESIZABLE
    );
    
    if (!window) {
        std::cerr << "SDL_CreateWindow failed: " << SDL_GetError() << std::endl;
        SDL_Quit();
        return 1;
    }

    // Create renderer (SDL3 uses different flags)
    SDL_Renderer* renderer = SDL_CreateRenderer(window, nullptr);
    if (!renderer) {
        std::cerr << "SDL_CreateRenderer failed: " << SDL_GetError() << std::endl;
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }

    // Main loop
    bool running = true;
    SDL_Event event;
    
    while (running) {
        // Handle events
        while (SDL_PollEvent(&event)) {
            switch (event.type) {
                case SDL_EVENT_QUIT:
                    running = false;
                    break;
                case SDL_EVENT_KEY_DOWN:
                    // SDL3 uses 'key' instead of 'keysym.sym'
                    if (event.key.key == SDLK_ESCAPE) {
                        running = false;
                    }
                    break;
            }
        }

        // Clear screen with a dark blue color
        SDL_SetRenderDrawColor(renderer, 0x1e, 0x1e, 0x2e, 0xff);
        SDL_RenderClear(renderer);

        // Draw a simple rectangle (pink/magenta)
        SDL_FRect rect = {350, 250, 100, 100};
        SDL_SetRenderDrawColor(renderer, 0xff, 0x69, 0xb4, 0xff);
        SDL_RenderFillRect(renderer, &rect);

        // Present frame
        SDL_RenderPresent(renderer);
        
        // Cap framerate to ~60 FPS
        SDL_Delay(16);
    }

    // Cleanup
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}