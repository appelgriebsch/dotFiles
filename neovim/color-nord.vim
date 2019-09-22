try
colorscheme nord
catch
  echo 'Nord Vim not installed. It should work after running :PlugInstall'
endtry

let g:lightline = {
\ 'colorscheme': 'nord',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
\ },
\ 'component_function': {
\   'cocstatus': 'coc#status',
\   'currentfunction': 'CocCurrentFunction'
\ },
\ }