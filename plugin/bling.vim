if !exists('g:bling_time') | let g:bling_time = 25 | en
if !exists('g:bling_count') | let g:bling_count = 2 | en
if !exists('g:bling_color') | let g:bling_color = 'red' | en

exec 'highlight BlingHilight ctermbg='.g:bling_color.' ctermfg='.g:bling_color

function! bling#hlight()
  let blink_count = g:bling_count
  let sleep_command = 'sleep ' . g:bling_time . 'ms'

  let param = getreg('/')
  let pos = getpos('.')

  while  blink_count > 0
    let blink_count -= 1

    let ring = matchadd('BlingHilight', '\%'.pos[1].'l\%'.pos[2].'v'.param)
    redraw

    exec l:sleep_command
    call matchdelete(ring)
    redraw

    if blink_count > 0 
      exec sleep_command
    endif
  endwhile

endfunction

if !exists('g:bling_no_map')
  noremap <silent> n n:call bling#hlight()<CR>
  noremap <silent> N N:call bling#hlight()<CR>
  noremap <silent> * *:call bling#hlight()<CR>
  noremap <silent> # #:call bling#hlight()<CR>
endif
