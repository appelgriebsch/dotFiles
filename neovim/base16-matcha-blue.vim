try
colorscheme base16-matcha-blue
catch
  echo 'Base16 Vim not installed. It should work after running :PlugInstall'
endtry

let g:lightline = {
\ 'colorscheme': 'base16_matcha_blue',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'readonly', 'branchname', 'fetchstatus', 'filecount', 'filename' ] ] ,
\   'right': [ [ 'lineinfo' ],
\              [ 'percent' ],
\              [ 'fileformat', 'fileencoding', 'filetype' ] ]
\ },
\ 'component_function': {
\   'filecount': 'gitline#FileCount',
\   'branchname': 'gitline#BranchName',
\   'filestatus': 'gitline#FileStatus',
\   'fetchstatus': 'gitline#FetchStatus'
\ },
\}

