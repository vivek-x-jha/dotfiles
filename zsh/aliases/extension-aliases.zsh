#!/usr/bin/env zsh

# These are special aliases that are triggered when a file name is passed as the command.
# Ex: if the pdf file extension is aliased to `acroread` (a popular Linux pdf reader),
# when running `file.pdf` that file will be open with `acroread`
autoload -Uz is-at-least
if is-at-least 4.2.0; then
  # Opens urls in terminal using browser specified by $BROWSER
  if [[ -n "$BROWSER" ]]; then
    _browser_fts=(htm html de org net com at cx nl se dk)
    for ft in $_browser_fts; do alias -s $ft='$BROWSER'; done
  fi

  # Opens C, C++, Tex and text files using editor specified by $EDITOR
  _editor_fts=(cpp cxx cc c hh h inl asc txt TXT tex)
  for ft in $_editor_fts; do alias -s $ft='$EDITOR'; done

  # Opens images using image viewer specified by $XIVIEWER
  if [[ -n "$XIVIEWER" ]]; then
    _image_fts=(jpg jpeg png gif mng tiff tif xpm)
    for ft in $_image_fts; do alias -s $ft='$XIVIEWER'; done
  fi

  # Opens videos and other media using mplayer
  _media_fts=(ape avi flv m4a mkv mov mp3 mpeg mpg ogg ogm rm wav webm)
  for ft in $_media_fts; do alias -s $ft=mplayer; done

  # Reading Docs
  alias -s pdf=acroread   # Opens up a document using acroread
  alias -s ps=gv          # Opens up a .ps file using gv
  alias -s dvi=xdvi       # Opens up a .dvi file using xdvi
  alias -s chm=xchm       # Opens up a .chm file using xchm
  alias -s djvu=djview    # Opens up a .djvu file using djview

  # Listing files inside a packed file
  alias -s zip="unzip -l" # Lists files inside a .zip file
  alias -s rar="unrar l"  # Lists files inside a .rar file
  alias -s tar="tar tf"   # Lists files inside a .tar file
  alias -s tar.gz="echo " # Lists files inside a .tar.gz file
  alias -s ace="unace l"  # Lists files inside a .ace file
fi
