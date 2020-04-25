try
let base16colorspace=256
colorscheme base16-default-dark
catch
  echo 'Seti Vim not installed. It should work after running :PlugInstall'
endtry

let g:lightline = {
\ 'colorscheme': 'powerline',
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
