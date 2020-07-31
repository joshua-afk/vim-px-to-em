"Vim ems to pixels

" A global variable that allows a user to change their default base font-size.
let g:px_to_em_base = get(g:, 'px_to_em_base', '16')

" px to em
function! VimPxEmConvertPxToEm(px)
  return printf("%0.3fem", 1.0/g:px_to_em_base*a:px)
endfunction

" em to px
function! VimPxEmConvertEmToPx(em)
  return printf("%.0fpx", round(g:px_to_em_base*str2float(a:em)))
endfunction

" px to rem
function! VimPxEmConvertPxToRem(px)
  return printf("%0.3frem", 1.0/g:px_to_em_base*a:px)
endfunction

" rem to px
function! VimPxEmConvertRemToPx(rem)
  return printf("%.0fpx", round(g:px_to_em_base*str2float(a:rem)))
endfunction

" Converts Selected pixels to ems vice versa.
" - convert_to: 'px' or 'em'
" - skipconfirmation: If skipconfirmation is set to 1, then the user will not
"   be promted at each change.
" - start_line: The first line to search.
" - end_line: The last line to search
function! VimPxEmConvert(convert_to, skip_confirmation, start_line, end_line)

  " If the skip confirmation value is set to 1, then don't prompt the user at
  " each change.
  if a:skip_confirmation
    let modifiers= "ge"
  else
    let modifiers= "gec"
  endif

  " Self explanitory
  if a:convert_to == "px"
    let search_for = '\v((0)?(\.)?\d+\.\d+)em'
    let conversion_function = "VimPxEmConvertEmToPx"
  elseif a:convert_to == "em"
    let search_for = '\v(\d+)px'
    let conversion_function = "VimPxEmConvertPxToEm"
  elseif a:convert_to == "rem"
    let search_for = '\v(\d+)px'
    let conversion_function = "VimPxEmConvertPxToRem"
  endif
  
  " Execute the command
  execute a:start_line . "," . a:end_line ."s/". search_for . "/" .'\='.conversion_function.'(submatch(1))' . "/" . modifiers
endfunction

"Available commands
command! -range -bang Em call VimPxEmConvert("em",<bang>1,<line1>,<line2>)
command! -range -bang Px call VimPxEmConvert("px", <bang>1,<line1>,<line2>)

command! -range -bang Rem call VimPxRemConvert("rem",<bang>1,<line1>,<line2>)
command! -range -bang Px call VimPxRemConvert("px", <bang>1,<line1>,<line2>)

command! -range=% -bang EmAll call VimPxEmConvert("em",<bang>1,<line1>,<line2>)
command! -range=% -bang RemAll call VimPxEmConvert("rem",<bang>1,<line1>,<line2>)
command! -range=% -bang PxAll call VimPxEmConvert("px", <bang>1,<line1>,<line2>)
