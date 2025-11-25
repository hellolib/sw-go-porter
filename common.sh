#!/bin/bash

#
# Set Colors
#

bold=$(tput bold)
underline=$(tput smul)
reset=$(tput sgr0)

black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)
grey=$(tput setaf 8)

#
# Headers and Logging
#

underline() { printf "${underline}${bold}%s${reset}\n" "$@" ; }
head()      { printf "\n${underline}${bold}${blue}%s${reset}\n\n" "$@" ; }
info()      { printf "${grey}➜ %s${reset}\n" "$@" ; }
success()   { printf "${green}✔ %s${reset}\n" "$@" ; }
error()     { printf "${red}✖ %s${reset}\n" "$@" ; }
warn()      { printf "${yellow}➜ %s${reset}\n" "$@" ; }
bold()      { printf "${bold}%s${reset}\n" "$@" ; }
