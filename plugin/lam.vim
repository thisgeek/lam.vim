""
"" Lam is a vim plugin for using vim-fugitive quickly. It steals mappings from
"" the excellent Janus project, and adds a few more helpers of my own
"" invention.
""

" Classic Janus mappings
nmap <leader>gb :Gblame<CR>
nmap <leader>gs :Git<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gc :Git commit<CR>

" Shortcut to load commit history in quickfix
nmap <leader>gl :Gclog<CR>
vmap <leader>gl :Gclog<CR>

" Shortcut browsing in the repo hosting provider
nmap <leader>gh :GBrowse<CR>
vmap <leader>gh :GBrowse<CR>

" Shortcut to push and force push
nmap <leader>gp :Git push<CR>
" TODO Avoid conflict with gf?
nmap <leader>gfp :Git push -f<CR>

" Shortcut for saving the current branch to origin
command! GSetUpstream execute "Git push -u origin" FugitiveHead()
nmap <leader>gsu :GSetUpstream<CR>

" TODO how to get current branch name
" TODO in mergetool: show message when there are no more conflicts

let g:EditorConfig_exclude_patterns = ['fugitive://.*']  " Keep editor config from conflicting with fugitive
let g:gist_post_private = 1                              " Make private gists by default

" Show the fugitive log for the current feature branch
function! DefaultBranch()
  let defaultBranch = execute("Git config --get init.defaultBranch")
  return strtrans(substitute(defaultBranch, '\n\+', '', ''))
endfunction

function! MergeBase()
  " TODO support branch arg
  let commit = execute("Git merge-base HEAD origin/" . DefaultBranch())
  return strtrans(substitute(commit, '\n\+', '', ''))
endfunction
command! GlogMergeBase execute "Gclog " . MergeBase() . "..HEAD"
nmap <leader>gm :GlogMergeBase<CR>

" Interactive rebase onto the default branch
command! RebaseOntoDefault execute "Git rebase -i origin/" . DefaultBranch()
nmap <leader>gr :RebaseOntoDefault<CR>

" Load stashes in the quickfix list
" Ref: https://github.com/tpope/vim-fugitive/issues/236#issuecomment-635628157
nmap <leader>gz :Gclog -g stash<CR>
