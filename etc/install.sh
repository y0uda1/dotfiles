#!/bin/bash

# シンボリックリンク作成用に絶対パスを持っておく
DIR=`pwd`

# dotfiles直下でしか実行できないようにしておく。
if [[ ! $DIR =~ /dotfiles$ ]]; then
  echo "cloneしてきたdotfiles直下で実行してください。"
  exit 1
fi

# prezto導入
if [ ! -d ~/.prezto ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
  curl https://raw.github.com/davidjrice/prezto_powerline/master/prompt_powerline_setup > ~/.zsh.prompts/prompt_powerline_setup
fi


# dotfiles直下にある.で始まるファイルをホームディレクトリ配下にリンクを貼る
for f in .??*
do
  [[ "$f" == ".git" ]] && continue
  [[ "$f" == ".DS_Store" ]] && continue

  if [ -e "~/$f" ]; then
    echo "ファイルが存在しています。"
  elif [ -d "~/$f" ]; then
    echo "ディレクトリが存在しています。"
  elif [ -L "~/$f" ]; then
    echo "リンクが存在しています。"
#        unlink "~/$f"
  else 
    echo "リンクを作成します。"
    ln -s "$DIR/$f" ~/"$f"
  fi
done

