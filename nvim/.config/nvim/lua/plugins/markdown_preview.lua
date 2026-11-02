-- Desc: Markdown Previewer
-- URL: https://github.com/selimacerbas/markdown-preview.nvim
-- URL: https://github.com/OXY2DEV/markview.nvim

--- @type LazySpec
return {
    { 'selimacerbas/markdown-preview.nvim', dependencies = { 'selimacerbas/live-server.nvim', ft = { 'markdown' } }, ft = { 'markdown' }, opts = { instance_mode = 'multi' } },
    {
        'OXY2DEV/markview.nvim',
        lazy = false,
        config = function()
            local mv_opts = {
                preview = {
                    hybrid_modes = { 'n', 'i' },
                    icon_provider = 'devicons', -- "mini" or "devicons"
                },
            }
            local mve_checkbox_opts = {}

            require('markview').setup(mv_opts)
            require('markview.extras.checkboxes').setup(mve_checkbox_opts)
        end,
    },
}
