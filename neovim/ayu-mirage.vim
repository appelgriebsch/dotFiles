try
" let ayucolor="light"  " for light version of theme
let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
colorscheme ayu
catch
  echo 'Ayu Vim not installed. It should work after running :PlugInstall'
endtry

let g:lightline = {
\ 'colorscheme': 'ayu_mirage',
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