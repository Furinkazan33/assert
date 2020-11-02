
#############################################################
# assert
# Author : Mathieu Vidalies https://github.com/Furinkazan33
#############################################################
# Utility functions
#############################################################

# Redirecting outputs to $1 file
redirect_start()
{
  local file=$1

  [ -z "$file" ] && { echo "Usage: redirect_start <file>"; return 1; }

  # Saving stdout to fd3
  exec 3>&1

  # Redirecting stderr and stdout to the file
  exec &>>$file
}

# Stopping redirection after redirect_start
redirect_stop()
{
  exec 1>&3
  exec 2>&3
}

accepted()
{
  [ -z "$1" ] || [ "$1" == "y" ] && return 0
  return 1
}

accept()
{
  echoc 0 PURPLE "$* ? (y/n)"
  read answer

  accepted "$answer" && return 0

  return 1
}


