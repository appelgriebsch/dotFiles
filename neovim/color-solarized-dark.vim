try
colorscheme solarized8
catch
  echo 'NeoSolarized not installed. It should work after running :PlugInstall'
endtry

let g:lightline = {
\ 'colorscheme': 'solarized',
\ }
