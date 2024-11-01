local setup = function()
    require("dap")
    require("dap-python").setup("python3")
end

MY_SIDEBAR = nil

local toggle = function()
    if MY_SIDEBAR == nil then
        local widgets = require("dap.ui.widgets")
        MY_SIDEBAR = widgets.sidebar(widgets.frames)
    end
    MY_SIDEBAR.toggle()
end

local change = function(view)
    local widgets = require("dap.ui.widgets")
    if MY_SIDEBAR ~= nil then
        MY_SIDEBAR.close()
    end
    MY_SIDEBAR = widgets.sidebar(widgets[view])
    MY_SIDEBAR.open()
end

local keys = {
    {
        "<localleader>dst", toggle
    },
    {
        "<localleader>dss", function() change("sessions") end
    },
    {
        "<localleader>dsc", function() change("scopes") end
    },
    {
        "<localleader>dsf", function() change("frames") end
    },
    {
        "<localleader>dsr", function() change("threads") end
    },
    {
        "<localleader>dse", function() change("expression") end
    },
    {
        "<localleader>drc",
        function()
            require('dap').run_to_cursor()
        end,
    },
    {
        "<localleader>d.",
        function()
            require('dap').focus_frame()
        end,
    },
    {
        "<localleader>dk",
        function()
            require('dap').up()
        end,
    },
    {
        "<localleader>dj",
        function()
            require('dap').down()
        end,
    },
    {
        "<localleader>dq",
        function()
            require('dap').terminate()
        end,
    },
    {
        "<localleader>dc",
        function()
            require('dap').continue()
        end,
    },
    {
        "<localleader>dn",
        function()
            require('dap').step_over()
        end,
    },
    {
        "<localleader>di",
        function()
            require('dap').step_over()
        end,
    },
    {
        "<localleader>dbt",
        function()
            require('dap').toggle_breakpoint()
        end,
    },
    {
        "<localleader>dbl",
        function()
            require('dap').list_breakpoints()
        end,
    },
    {
        "<localleader>dbc",
        function()
            require('dap').clear_breakpoints()
        end,
    },
    {
        "<localleader>drt",
        function()
            require('dap').repl.toggle({}, "below split")
        end,
    },
}

local lazy = function()
    return {
        "nvim-dap",
        after = setup,
        keys = keys,
    }
end

return {
    lazy = lazy,
}
