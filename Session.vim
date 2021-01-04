let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Code/Elm/MIDI-Mediator
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +9 src/Main.elm
badd +3 term://.//30869:/run/current-system/sw/bin/bash
badd +26 term://.//2989:/run/current-system/sw/bin/bash
badd +1 cljs/midi-mediator/src/main/midi-mediator/main.cljs
badd +39 index.html
badd +5 cljs/midi-mediator/src/main/midi-mediator/lfo-worker.cljs
badd +3 cljs/midi-mediator/compile-cljs.sh
badd +3 compile-elm.sh
badd +3 term://.//5559:/run/current-system/sw/bin/bash
badd +13 term://.//30873:/run/current-system/sw/bin/bash
badd +45 cljs/midi-mediator/src/main/midi_mediator/main.cljs
badd +32 cljs/midi-mediator/src/main/midi_mediator/lfo_worker.cljs
badd +17 js/LFO-Worker.js
badd +0 term://.//4156:/run/current-system/sw/bin/bash
badd +1 ~/Code/ClojureScript/myworkertest/shadow-cljs.edn
badd +4 cljs/midi-mediator/shadow-cljs.edn
badd +3 cljs/midi-mediator/watch-cljs.sh
argglobal
%argdel
edit index.html
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
2wincmd k
wincmd w
wincmd w
wincmd w
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
3wincmd k
wincmd w
wincmd w
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 32 + 36) / 73)
exe 'vert 1resize ' . ((&columns * 147 + 147) / 295)
exe '2resize ' . ((&lines * 32 + 36) / 73)
exe 'vert 2resize ' . ((&columns * 147 + 147) / 295)
exe '3resize ' . ((&lines * 5 + 36) / 73)
exe 'vert 3resize ' . ((&columns * 147 + 147) / 295)
exe '4resize ' . ((&lines * 27 + 36) / 73)
exe 'vert 4resize ' . ((&columns * 147 + 147) / 295)
exe '5resize ' . ((&lines * 14 + 36) / 73)
exe 'vert 5resize ' . ((&columns * 147 + 147) / 295)
exe '6resize ' . ((&lines * 17 + 36) / 73)
exe 'vert 6resize ' . ((&columns * 147 + 147) / 295)
exe '7resize ' . ((&lines * 10 + 36) / 73)
exe 'vert 7resize ' . ((&columns * 147 + 147) / 295)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 174 - ((16 * winheight(0) + 16) / 32)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
174
normal! 09|
wincmd w
argglobal
if bufexists("js/LFO-Worker.js") | buffer js/LFO-Worker.js | else | edit js/LFO-Worker.js | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 1 - ((0 * winheight(0) + 16) / 32)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
wincmd w
argglobal
if bufexists("term://.//30869:/run/current-system/sw/bin/bash") | buffer term://.//30869:/run/current-system/sw/bin/bash | else | edit term://.//30869:/run/current-system/sw/bin/bash | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 6 - ((0 * winheight(0) + 2) / 5)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
6
normal! 0
wincmd w
argglobal
if bufexists("cljs/midi-mediator/src/main/midi_mediator/main.cljs") | buffer cljs/midi-mediator/src/main/midi_mediator/main.cljs | else | edit cljs/midi-mediator/src/main/midi_mediator/main.cljs | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 47 - ((10 * winheight(0) + 13) / 27)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
47
normal! 013|
lcd ~/Code/Elm/MIDI-Mediator
wincmd w
argglobal
if bufexists("~/Code/Elm/MIDI-Mediator/cljs/midi-mediator/src/main/midi_mediator/lfo_worker.cljs") | buffer ~/Code/Elm/MIDI-Mediator/cljs/midi-mediator/src/main/midi_mediator/lfo_worker.cljs | else | edit ~/Code/Elm/MIDI-Mediator/cljs/midi-mediator/src/main/midi_mediator/lfo_worker.cljs | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 30 - ((0 * winheight(0) + 7) / 14)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
30
normal! 011|
lcd ~/Code/Elm/MIDI-Mediator
wincmd w
argglobal
if bufexists("term://.//4156:/run/current-system/sw/bin/bash") | buffer term://.//4156:/run/current-system/sw/bin/bash | else | edit term://.//4156:/run/current-system/sw/bin/bash | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 274 - ((16 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
274
normal! 06|
lcd ~/Code/Elm/MIDI-Mediator
wincmd w
argglobal
if bufexists("term://.//30873:/run/current-system/sw/bin/bash") | buffer term://.//30873:/run/current-system/sw/bin/bash | else | edit term://.//30873:/run/current-system/sw/bin/bash | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 631 - ((9 * winheight(0) + 5) / 10)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
631
normal! 0
wincmd w
4wincmd w
exe '1resize ' . ((&lines * 32 + 36) / 73)
exe 'vert 1resize ' . ((&columns * 147 + 147) / 295)
exe '2resize ' . ((&lines * 32 + 36) / 73)
exe 'vert 2resize ' . ((&columns * 147 + 147) / 295)
exe '3resize ' . ((&lines * 5 + 36) / 73)
exe 'vert 3resize ' . ((&columns * 147 + 147) / 295)
exe '4resize ' . ((&lines * 27 + 36) / 73)
exe 'vert 4resize ' . ((&columns * 147 + 147) / 295)
exe '5resize ' . ((&lines * 14 + 36) / 73)
exe 'vert 5resize ' . ((&columns * 147 + 147) / 295)
exe '6resize ' . ((&lines * 17 + 36) / 73)
exe 'vert 6resize ' . ((&columns * 147 + 147) / 295)
exe '7resize ' . ((&lines * 10 + 36) / 73)
exe 'vert 7resize ' . ((&columns * 147 + 147) / 295)
tabnext 1
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToOF
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
