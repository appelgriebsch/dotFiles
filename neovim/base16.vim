try
colorscheme base16-solarflare
catch
  echo 'Base16 Vim not installed. It should work after running :PlugInstall'
endtry

let g:lightline = {
\ 'colorscheme': 'deus',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'currentfunction', 'readonly', 'filename', 'modified', 'gitbranch', 'cocstatus'] ]
\ },
\ 'component_function': {
\   'cocstatus': 'coc#status',
\   'currentfunction': 'CocCurrentFunction',
\   'gitbranch': 'fugitive#head'
\ },
\ }
