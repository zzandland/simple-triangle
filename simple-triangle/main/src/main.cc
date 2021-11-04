#define GL_SILENCE_DEPRECATION
#include <OpenGL/gl3.h>
#include <SDL.h>

#include <iostream>

void Render(SDL_Window* window, const SDL_GLContext& context) {
  SDL_GL_MakeCurrent(window, context);

  glClearColor(0.3f, 0.7f, 0.0f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

  SDL_GL_SwapWindow(window);
}

bool RunMainLoop(SDL_Window* window, const SDL_GLContext& context) {
  SDL_Event event;

  // Each loop we will process any events in the queue
  while (SDL_PollEvent(&event)) {
    switch (event.type) {
      // Quit signal returns false
      case SDL_QUIT:
        return false;

      case SDL_KEYDOWN:
        // Esc signals for quit thus returns false
        if (event.key.keysym.sym == SDLK_ESCAPE) {
          return false;
        }
        break;

      default:
        break;
    }
  }

  // Perform rendering for this frame
  Render(window, context);

  // Returning true means we want to keep looping
  return true;
};

void RunApplication() {
  uint32_t width = 640, height = 640;

  // Create a new SDL window based on OpenGL
  SDL_Window* window = SDL_CreateWindow(
      "A Simple Triangle", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
      width, height,
      SDL_WINDOW_RESIZABLE | SDL_WINDOW_OPENGL | SDL_WINDOW_ALLOW_HIGHDPI);

  // Obtain an OpenGL context based on our window
  SDL_GLContext context = SDL_GL_CreateContext(window);

  // Setup some basic global OpenGL states
  glClearDepthf(1.0f);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LEQUAL);
  glEnable(GL_CULL_FACE);
  glViewport(0, 0, width, height);

  while (RunMainLoop(window, context)) {
    // Just waiting for the main loop to end.
  }

  // Clean up after ourselves.
  SDL_GL_DeleteContext(context);
  SDL_DestroyWindow(window);
}

int main(int, char*[]) {
  if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS) == 0) {
    std::cout << "Successfully initialised SDL!" << std::endl;

    RunApplication();

    SDL_Quit();
  } else {
    std::cout << "Failed to initialise SDL!" << std::endl;
  }

  return 0;
}
