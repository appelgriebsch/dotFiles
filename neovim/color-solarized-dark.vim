try
colorscheme solarized8
catch
  echo 'NeoSolarized not installed. It should work after running :PlugInstall'
endtry

let g:lightline = {
\ 'colorscheme': 'solarized',
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