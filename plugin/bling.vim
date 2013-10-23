if !exists('g:bling_no_expr') | let g:bling_no_expr = 0   | en
if !exists('g:bling_no_map')  | let g:bling_no_map = 0    | en

if !exists('g:bling_count')   | let g:bling_count = 2     | en
if !exists('g:bling_time')    | let g:bling_time = 35     | en

if !exists('g:bling_color')   | let g:bling_color = 'red' | en

exec 'highlight BlingHilight'
      \ .' ctermbg='.g:bling_color
      \ .' ctermfg='.g:bling_color
      \ .' guibg='  .g:bling_color
      \ .' guifg='  .g:bling_color

function! BlingHighight()
  let blink_count = g:bling_count
  let sleep_command = 'sleep ' . g:bling_time . 'ms'

  let param = getreg('/')
  let pos = getpos('.')

  let pattern = '\%'.pos[1].'l\%'.pos[2].'c'.param

  if &ignorecase == 1 || &smartcase == 1
    let pattern = pattern.'\c'
  endif

  " open folds
  normal zv

  while  blink_count > 0
    let blink_count -= 1

    let ring = matchadd('BlingHilight', pattern)
    redraw

    exec l:sleep_command
    call matchdelete(ring)
    redraw

    if blink_count > 0 
      exec sleep_command
    endif
  endwhile

endfunction

function! BlingExpressionHighlight()
  let cmd_type = getcmdtype()
  if cmd_type == '/' || cmd_type == '?'
    return "\<CR>:call BlingHighight()\<CR>"
  endif
  return "\<CR>"
endfunction


if !g:bling_no_map
  nnoremap <silent> n n:call BlingHighight()<CR>
  nnoremap <silent> N N:call BlingHighight()<CR>
  nnoremap <silent> * *:call BlingHighight()<CR>
  nnoremap <silent> # #:call BlingHighight()<CR>

  if !g:bling_no_expr
    cnoremap <silent> <expr> <enter> BlingExpressionHighlight()
  endif
endif
