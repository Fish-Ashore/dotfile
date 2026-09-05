if status is-interactive
    # Commands to run in interactive sessions can go here
end

# --- 环境变量 ---
set -gx EDITOR vim
set -gx LANG en_US.UTF-8

# --- PATH ---
fish_add_path ~/.local/bin

# --- 别名 ---
alias ll='ls -l'
alias la='ls -a'
alias gs='git status'
alias ..='cd ..'

# --- 函数 ---
function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end

# --- 提示符 ---
# function fish_prompt
#     echo -n (prompt_pwd) ' ❯ '
# end

# --- 其他 ---
# 关闭欢迎信息
set -g fish_greeting ""

starship init fish | source
