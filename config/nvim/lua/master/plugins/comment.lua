require('Comment').setup{

    ---Add a space b/w comment and the line
    padding = true,

    ---Whether the cursor should stay at its position
    sticky = true,

    ---Lines to be ignored while (un)comment
    ignore = nil,

    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        line = 'cc',
        ---Block-comment toggle keymap
        block = 'cb',
    },

    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        line = 'cc',
        ---Block-comment keymap
        block = 'cb',
    },

}
