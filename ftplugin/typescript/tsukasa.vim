let s:save_cpo = &cpo
set cpo&vim

command! TsuHint silent! :call tsukasa#hint()
command! TsuHintPopup :call tsukasa#popup_hint()
noremap <silent> <buffer> <Plug>(TsuHint) :<c-u>TsuHint<CR>
noremap <silent> <buffer> <Plug>(TsuHintPopup) :<c-u>TsuHintPopup<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
