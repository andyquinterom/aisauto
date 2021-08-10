ssh_connect <- function(host = "127.0.0.1", port = 22, username = "root") {
  ssh_conn <- paste0(username, "@", host)
  ssh_cmd <- paste(
    "ssh -oStrictHostKeyChecking=no",
    "-p", port, ssh_conn)

  creds_obj <- list(
    host = host,
    port = port,
    username = username,
    scp_from = function(remote_file, local_file) {
      command <- paste0(
        "scp -oStrictHostKeyChecking=no -rP ",
        port, " ",
        ssh_conn,
        ":", remote_file,
        " ", local_file
      )
      system(command)
    },
    scp_to = function(local_file, remote_file) {
      command <- paste0(
        "scp -oStrictHostKeyChecking=no -rP ",
        port, " ",
        local_file, " ",
        ssh_conn, ":",
        remote_file
      )
      system(command)
    },
    exec = function(text = NULL, script = NULL) {
      if (!is.null(text)) {
        script <- tempfile()
        writeLines(
          text = text,
          con = script
        )
      }
      command <- paste(
        ssh_cmd,
        "'sh -s' <",
        script
      )
      system(command, intern = TRUE)
    }
  ) 

  class(creds_obj) <- "ssh_connection"

  return(creds_obj)

}
