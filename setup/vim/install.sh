#!/bin/bash

touch ~/.vimrc
truncate -s 0 ~/.vimrc

# basic
cat basic.vimrc >> ~/.vimrc

# themes
mkdir -p ~/.vim/colors
cp monokai.vim ~/.vim/colors
cat color.vimrc >> ~/.vimrc
