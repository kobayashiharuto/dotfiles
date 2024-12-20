#/bin/sh

# function to create symbolic links
create_symlink() {
    local FILENAME=$1
    local SOURCE_FILE="$HOME/dotfiles/$FILENAME"
    local TARGET_FILE="$HOME/$FILENAME"

    # ソースがあるか確認
    if [ ! -e "$SOURCE_FILE" ]; then
        echo "$SOURCE_FILE does not exist in $HOME/dotfiles"
        return 1
    fi

    # 既にあったら何もしない
    if [ -e "$TARGET_FILE" ]; then
        echo "already exist: $FILENAME"
        return 1
    fi

    ln -s "$SOURCE_FILE" "$TARGET_FILE"
    echo "created symbolic link: $FILENAME"
}

# checks wheather desired command is installed
command_ok() {
    local COMMAND_NAME=$1

    if ! which $COMMAND_NAME > /dev/null 2>&1; then
        echo "not installed: $COMMAND_NAME"
        return 1
    fi
    return 0
}

# create symbolic link and related files
echo "[start]   create symbolic link"
create_symlink ".vimrc"
create_symlink ".tmux.conf"
create_symlink ".gitconfig"
touch ~/.zshrc
echo "[end]     create symbolic link"
echo ""

# check required tools
echo "[start]   check required tools"
IS_READY=1
command_ok "git" || IS_READY=0
command_ok "vim" || IS_READY=0
command_ok "curl" || IS_READY=0
command_ok "tmux" || IS_READY=0
if [ $IS_READY -eq 0 ]; then
    echo "[abort]   check required tools"
    echo "install missing tools and re-run this script."
    exit 1
fi
echo "[end]     check required tools"
echo ""
