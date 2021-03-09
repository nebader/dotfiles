# function,function_*,path,env,alias,completion,grep,prompt,nvm,rvm,custom

#############
# Functions #
#############

# Open man page as PDF
function manpdf() {
  man -t "${1}" | open -f -a /Applications/Preview.app/
}

# Extract many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar -jxvf "$1"                        ;;
      *.tar.gz)   tar -zxvf "$1"                        ;;
      *.bz2)      bunzip2 "$1"                          ;;
      *.dmg)      hdiutil mount "$1"                    ;;
      *.gz)       gunzip "$1"                           ;;
      *.tar)      tar -xvf "$1"                         ;;
      *.tbz2)     tar -jxvf "$1"                        ;;
      *.tgz)      tar -zxvf "$1"                        ;;
      *.zip)      unzip "$1"                            ;;
      *.ZIP)      unzip "$1"                            ;;
      *.pax)      cat "$1" | pax -r                     ;;
      *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
      *.Z)        uncompress "$1"                       ;;
      *) echo "'$1' cannot be extracted/mounted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file to extract"
  fi
}

#########################
# Environment variables #
#########################

export PATH=$PATH:~/Scripts
export PATH="~/miniconda3/bin:$PATH"

###########
# Aliases #
###########

alias ld="ls -ld */" # List directories in long format
# Recursively remove .DS_Store files
alias cleanupds="find . -type f -name '*.DS_Store' -ls delete"

<<<<<<< HEAD:bash/.bashrc

=======
# added by Miniconda3 installer
export PATH="/Users/baderne/miniconda3/bin:$PATH"
>>>>>>> 60a16c4b0ddc26a8c9b8050e2570fbc11cae3cb7:bashrc
