let s:save_cpo = &cpo
set cpo&vim

let s:winid = -1

function! tsukasa#hint() abort
  let content = tsuquyomi#hint()
  silent pedit __TsuquyomiScratch__
  silent wincmd P
  setlocal modifiable noreadonly
  setlocal nobuflisted buftype=nofile bufhidden=wipe ft=typescript
  put =content
  0d_
  setlocal nomodifiable readonly
  silent wincmd p
endfunction

function s:sort(x, y) abort
  return strlen(a:x) < strlen(a:y)
endfunction

function! tsukasa#popup_hint() abort
  if s:winid != -1
    call popup_close(s:winid)
    let s:winid = -1
  endif
  let l:content = tsuquyomi#hint()
  let l:contents = split(l:content, '\n')

  let l:border_size = 2 " both side of `|` and top and bottom `-`

  " col position
  let l:current_col = col('.')
  let l:max_width = strlen(sort(copy(l:contents), function('s:sort'))[0])

  let l:col = l:current_col
  if l:current_col + l:max_width > &columns
    " popup is overflowed
    if l:max_width > &columns
      let l:col = 0
    else
      " If popup is overflow from buffer window, popup like followings.
      "
      " +=========================+
      " |      +-----------------+|
      " |      |const foo: string||
      " |      +-----------------+|
      " |  { bar, baz, bazz, foo }|
      " |                    ^    |
      " |     cursor is here |    |
      " +=========================+
      "
      let l:col = l:current_col + (&columns - (l:current_col + l:max_width + l:border_size)) + 1
    endif
  endif

  " line position
  let l:current_line = winline()
  let l:popup_height = len(l:contents) + l:border_size

  " Calc popup overflow size
  for l:line in l:contents
    let l:width = strlen(l:line)
    if l:width + l:border_size >= &columns
      let l:popup_height += 1
    endif
  endfor

  let l:lnum = l:current_line < l:popup_height
    \ ? l:current_line + 1
    \ : l:current_line - l:popup_height

  let s:winid = popup_create(split(l:content, '\n'), {
    \ 'line': l:lnum,
    \ 'col': l:col,
    \ 'border': [1, 1, 1, 1],
    \ 'moved': 'WORD',
    \ })
  let bufnr = winbufnr(s:winid)
  call setbufvar(winbufnr(s:winid), '&filetype', &filetype)
  return s:winid
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
