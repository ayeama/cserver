#include <alib.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "routes/user.c"

void signal_handler(int signum) {
  // a_log_debug("received signal: %s", sigabbrev_np(signum));
  exit(EXIT_SUCCESS);
}

int main() {
  log_level = LOG_LEVEL_DEBUG;
  a_log_info("starting");

  signal(SIGINT, signal_handler);

  a_http_handler_t handler = {
      .funcs = NULL,
  };

  a_http_handle_func(&handler, "POST /users", route_user_create);
  a_http_handle_func(&handler, "GET /users", route_user_read_many);
  a_http_handle_func(&handler, "GET /users/<id>", route_user_read_one);
  a_http_handle_func(&handler, "PUT /users/<id>", route_user_update);
  a_http_handle_func(&handler, "DELETE /users/<id>", route_user_delete);

  a_http_server_t server = {
      .host = "127.0.0.1",
      .port = 8000,
      .handler = &handler,
  };

  a_http_serve(&server);

  return EXIT_SUCCESS;
}
