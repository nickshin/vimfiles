#!/bin/bash
#
# vim_fetch.sh by nick shin <nshin@estss.com>
#
# this file can be found at: https://github.com/nickshin/vimfiles
#
# for best results, symbolic link to the folder $dst below for ~/.vim


# ============================================================
# note: removed .vimrc appends
# + this way, i can run this script periodically to get latest
# + instead, just make a note of it at the end of the run...
# ============================================================


#dst=~/.vim
dst=`pwd`'/dotvim.test'

downloads=__downloads

# ============================================================

bundle_setup()
{
	mkdir -p $dst/autoload $dst/bundle
	mkdir -p $dst/../$downloads
}

housekeeping()
{
	echo "."
	echo "."
	echo "don't forget to add the following to your .vimrc"
	echo 'execute pathogen#infect()'
	echo 'call pathogen#helptags()'
	echo "."
	echo "Happy Vimming!"
}

# ============================================================

bundle_git()
{
	cd $dst/bundle
	# ------------------------------------------------------------
	git clone git://github.com/tpope/vim-pathogen
		cp vim-pathogen/autoload/* $dst/autoload/.
#		echo execute pathogen#infect() >> $dst/.vimrc

	# ------------------------------------------------------------
	git clone git://github.com/tpope/vim-fugitive
	git clone git://github.com/tpope/vim-jdaddy
	git clone git://github.com/tpope/vim-repeat
	git clone git://github.com/tpope/vim-surround
	git clone git://github.com/tpope/vim-unimpaired

	# ------------------------------------------------------------
	git clone git://github.com/Shougo/neomru.vim neomru
	git clone git://github.com/Shougo/unite.vim
	git clone git://github.com/Shougo/vimproc
		cd vimproc
		make
# WARNING: doc file sez no work on Cygwin - use GitBash
		cd ..
	git clone git://github.com/Shougo/vimshell.vim vimshell

	# ------------------------------------------------------------
	git clone git://github.com/rking/ag.vim ag
	git clone git://github.com/sjl/gundo.vim gundo
	git clone git://github.com/godlygeek/tabular.git
	git clone git://github.com/tommcdo/vim-exchange
	git clone git://github.com/vim-scripts/ZoomWin
	git clone git://github.com/vim-scripts/matchit.zip
	git clone git://github.com/msanders/snipmate.vim snipmate
	git clone git://github.com/rstacruz/sparkup
		cd sparkup
		make vim-pathogen
		cd ..
	git clone git://github.com/scrooloose/syntastic
	git clone git://github.com/marijnh/tern_for_vim
		cd tern_for_vim
		npm install
		cd ..
	git clone git://github.com/joonty/vdebug
	git clone git://github.com/bling/vim-airline
		# i like the inactive line a little brighter
		perl -pi -e 's/303030/a0a0a0/' vim-airline/autoload/airline/themes/dark.vim
	git clone git://github.com/maksimr/vim-jsbeautify
		cd vim-jsbeautify
		git submodule update --init --recursive
		cd ..
	git clone git://github.com/elzr/vim-json
	git clone git://github.com/Valloric/YouCompleteMe
		cd YouCompleteMe
		git submodule update --init --recursive
#		sudo apt-get install build-essential cmake
#		sudo apt-get install python-dev
		./install.sh --clang-completer
		cd ..
}

# ============================================================

bundle_setup
bundle_git
housekeeping

