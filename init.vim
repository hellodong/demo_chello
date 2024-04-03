set nu
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

call plug#begin()

Plug 'preservim/nerdtree'
Plug 'Yggdroot/LeaderF', {'tag':'*', 'do': ':LeaderfInstallCExtension' }

" Plug 'preservim/tagbar', {'tag' : '*'}
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'autozimu/LanguageClient-neovim', {'branch': 'next'}

Plug 'vim-airline/vim-airline', {'tag': '*'}
Plug 'neovim/nvim-lspconfig', {'tag': '*'}
Plug 'hrsh7th/nvim-cmp' 
Plug  'hrsh7th/cmp-nvim-lsp'
Plug  'saadparwaiz1/cmp_luasnip' 
Plug  'L3MON4D3/LuaSnip' 

call plug#end()


" set nerdtree
" autocmd vimenter * NERDTree
let g:NERDTreeWinSize = 30
map <F3> :NERDTreeMirror <CR>
map <F3> :NERDTreeToggle <CR>

let g:Lf_Ctags = "D:/ctagsp5.9/ctags.exe"
let g:Lf_CtagsFuncOpts = {
            \ 'c': '--c-kinds=fp'
            \ }

noremap <F2> :LeaderfFunction!<cr>
noremap <F5> :LeaderfFile<cr>

" let $GTAGSLABEL = 'native'
" let $GTAGSCONF = 'D:/GNU_global/share/gtags/gtags.conf'
" let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg']
" let g:gutentags_ctags_tagfile = '.tags'
" let g:gutentags_modules = []
 
" if executable('gtags-cscope') && executable('gtags')
"    let g:gutentags_modules += ['gtags_cscope']
"endif
"let g:gutentags_cache_dir = expand('C:/Users/zxu/AppData/Local/nvim-data/cache/tags')
"let g:gutentags_auto_add_gtags_cscope = 1

" how to copy to clipboard in vim of Bash on windows
autocmd TextYankPost * if v:event.operator ==# 'y' | call system('/c/Windows/System32/clip.exe', @0) | endif

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

nnoremap <silent> <F4> :call ToggleQuickFix()<cr>

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#fnametruncate = 16
let g:airline#extensions#tabline#fnamecollapse = 2
let g:airline#extensions#tabline#buffer_idx_mode = 1

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

lua << EOF
-- Setup language servers.
vim.lsp.set_log_level("debug")

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
	capabilities = capabilities,
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '<leader>d', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<C-d>', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<C-i>', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-h>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<C-r>', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})


-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-m>'] = cmp.mapping.scroll_docs(4),
    ['<C-c>'] = cmp.mapping.complete(),
    ['<C-v>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }),
}
EOF

