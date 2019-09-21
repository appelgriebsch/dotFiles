try
" let ayucolor="light"  " for light version of theme
let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
colorscheme ayu
catch
  echo 'Ayu Vim not installed. It should work after running :PlugInstall'
endtry

" space line theme tbd
let g:spaceline_colorscheme = 'space'
