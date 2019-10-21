if !exists('g:bling_no_expr')   | let g:bling_no_expr  = 0  | en
if !exists('g:bling_no_map')    | let g:bling_no_map   = 0  | en

if !exists('g:bling_count')   | let g:bling_count = 2     | en
if !exists('g:bling_time')    | let g:bling_time  = 35    | en

if !exists('g:bling_color_fg')   | let g:bling_color_fg = 'red' | en
if !exists('g:bling_color_bg')   | let g:bling_color_bg = 'black' | en
if !exists('g:bling_color_gui_fg')   | let g:bling_color_gui_fg = 'red' | en
if !exists('g:bling_color_gui_bg')   | let g:bling_color_gui_bg = 'black' | en
if !exists('g:bling_color_cterm')   | let g:bling_color_cterm = 'reverse' | en
if !exists('g:bling_color_term')   | let g:bling_color_term = 'reverse' | en

let s:bling_disabled = 0

exec 'highlight BlingHilight'
      \ .' ctermbg='.g:bling_color_bg
      \ .' ctermfg='.g:bling_color_fg
      \ .' guibg='  .g:bling_color_gui_bg
      \ .' guifg='  .g:bling_color_gui_fg
      \ .' cterm='.g:bling_color_cterm
      \ .' term='.g:bling_color_term

function! BlingDisable()
    let s:bling_disabled=1
endfunction

function! BlingEnable()
    let s:bling_disabled=0
endfunction

function! BlingToggle()
  if s:bling_disabled
    call BlingEnable()
  else
    call BlingDisable()
  endif
endfunction


function! BlingHighight()
  if s:bling_disabled
    return
  endif

  let blink_count = g:bling_count
  let sleep_command = 'sleep ' . g:bling_time . 'ms'

  let param = getreg('/')

  " find the start and end columns of the current match so that we can
  " use matchaddpos below
  let match_start_pos = getcurpos()
  call search(param, 'ceW')
  let match_end_pos = getcurpos()
  call cursor(match_start_pos[1:])

  " open folds
  normal zv

  while  blink_count > 0
    let blink_count -= 1

    let ring = matchaddpos('BlingHilight', [ [ match_start_pos[1], match_start_pos[2], match_end_pos[2] - match_start_pos[2] + 1 ] ])
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
  let current_mode = mode()
  let in_visual_mode = current_mode == "v" ||
                     \ current_mode == "V" ||
                     \ current_mode == ""
  if (cmd_type == '/' || cmd_type == '?') && !in_visual_mode
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
