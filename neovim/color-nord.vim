try
colorscheme nord
catch
  echo 'Nord Vim not installed. It should work after running :PlugInstall'
endtry

let g:lightline = {
\ 'colorscheme': 'nord',
\ }
