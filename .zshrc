zstyle ":completion:*:commands" rehash 1
########################################
# Options
setopt print_eight_bit  # 日本語ファイル名を表示可能にする
setopt no_flow_control  # フローコントロールを無効にする
setopt interactive_comments  # '#' 以降をコメントとして扱う
setopt auto_cd  # ディレクトリ名だけでcdする
setopt share_history  # 同時に起動したzshの間でヒストリを共有する
setopt hist_ignore_all_dups  # 同じコマンドをヒストリに残さない
setopt hist_ignore_space  # スペースから始まるコマンド行はヒストリに残さない
setopt hist_reduce_blanks  # ヒストリに保存するときに余分なスペースを削除する
setopt nonomatch # curl などで ? や & をエスケープなしで使いたい
setopt IGNOREEOF # Ctrl+Dでログアウトしてしまうことを防ぐ

ZLE_REMOVE_SUFFIX_CHARS=$'' # ファイル名を補完した後に挿入されたスペースが消えてしまう

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

autoload -Uz colors && colors # プロンプトへ色を付ける
export LANG=ja_JP.UTF-8 # 日本語を使用

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    autoload -Uz compinit && compinit
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $(brew --prefix)/opt/zsh-git-prompt/zshrc.sh
fi

# 環境変数
typeset -U path PATH
path=(
    /opt/homebrew/bin(N-/)
    /opt/homebrew/sbin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    /usr/bin
    /usr/sbin
    /bin
    /sbin
    /Library/Apple/usr/bin
)

# Git リポジトリ以外では $(git_super_status) を表示させたくない場合
git_prompt() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = true ]; then
        PROMPT="%F{034}%h%f:%F{020}%~%f $(git_super_status)"$'\n'"%# "
    else
        PROMPT="%F{034}%h%f:%F{020}%~%f "$'\n'"%# "
    fi
}

# コマンド実行結果のあとに空行を挿入する
add_newline() {
    if [[ -z $PS1_NEWLINE_LOGIN ]]; then
        PS1_NEWLINE_LOGIN=true
    else
        printf '\n'
    fi
}

precmd() {
    git_prompt
    add_newline
}

# Volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

#android emulator
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/xiaoyuanzhiwang/.sdkman"
[[ -s "/Users/xiaoyuanzhiwang/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/xiaoyuanzhiwang/.sdkman/bin/sdkman-init.sh"

# Setting PATH for Flutter
export PATH="$PATH:/Users/xiaoyuanzhiwang/development/flutter/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"

# エイリアス
alias python='python3'
alias gac='git add . && git ci -m'
alias gp='git push'
alias gpl='git pull'
alias co='git checkout'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias sudo='sudo ' # sudo の後のコマンドでエイリアスを有効にする

########################################
# OS 別の設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        #Linux用の設定
        alias ls='ls -F --color=auto'
        ;;
esac

# github cli
eval "$(gh completion -s zsh)"

# mysql
export PATH="/usr/local/opt/mysql-client@5.7/bin:$PATH"

# エディタ
export EDITOR=vscode

# direnv
eval "$(direnv hook zsh)"

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh
