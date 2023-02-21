# Do not truncate path in repos
SPACESHIP_DIR_TRUNC=11
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_CHAR_SYMBOL_ROOT="#"

SPACESHIP_RPROMPT_ADD_NEWLINE=false

SPACESHIP_VI_MODE_SHOW=true
SPACESHIP_VI_MODE_INSERT=⏵
SPACESHIP_VI_MODE_NORMAL=⏷
SPACESHIP_VI_MODE_COLOR=grey
SPACESHIP_CHAR_SYMBOL=" "

# Add a custom vi-mode section to the prompt
# See: https://github.com/spaceship-prompt/spaceship-vi-mode
spaceship add --before char vi_mode
spaceship remove gcloud

SPACESHIP_PROMPT_PREFIXES_SHOW=false
