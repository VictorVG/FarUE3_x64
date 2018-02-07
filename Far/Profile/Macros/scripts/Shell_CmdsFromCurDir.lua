--
-- Displays the commands (from the command history) that have been launched
-- from the current directory.
-- "Enter" executes the command again
-- "Shift+Enter" executes the command in a separate window
-- "Ctrl+Enter" copies the command to the command line but does not execute it
--

local function sortTableByField(pMenuItems, fieldName, sortAscending)
    table.sort(pMenuItems, function(a,b)
        local v1, v2 = a[fieldName], b[fieldName]
        if type(v1) == "string" then
            v1, v2 = v1:lower(), v2:lower()
        end
        if sortAscending then
            return v1 < v2
        else
            return v1 > v2
        end
    end)
end


-- Re-sorts the menu by the given field. Returns the index of the current entry
-- after re-sorting
local function resortMenuByField(pMenuItems, curIndex, fieldName, sortState, allowToggleDirection)
    local curText = pMenuItems[curIndex].text
    if sortState.sortField == fieldName then
        -- Toggle the order, if necessary
        if allowToggleDirection then
            sortState[fieldName] = not sortState[fieldName]
        end
    else
        -- Switch the field, retain the order
        sortState.sortField = fieldName
    end
    sortTableByField(pMenuItems, sortState.sortField, sortState[fieldName])
    local newIndex
    for i = 1, #pMenuItems do
        if pMenuItems[i].text == curText then
            newIndex = i
            break
        end
    end
    return newIndex
end


local function getShortcutsDescription(breakKeys)
    sortTableByField(breakKeys, "BreakKey", true)
    local result = ""
    for i = 1, #breakKeys do
        if breakKeys[i].descr then
            if result ~= "" then
                result = result.."\n"
            end
            result = result..breakKeys[i].shortcutName.." -- "..breakKeys[i].descr
        end
    end
    return result
end


local function getSortingDescription(sortState)
    local fieldToLetterMap = {
        execTime = "T",
        command  = "C"
    }
    local sortLetter = fieldToLetterMap[sortState.sortField]
    local sortOrderLetter
    if sortLetter ~= nil then
        sortOrderLetter = sortState[sortState.sortField] and "в†‘" or "в†“"
    else
        sortOrderLetter = ""
    end
    return sortLetter..sortOrderLetter
end


local function trim(str)
  return str:gsub("^%s*(.-)%s*$", "%1")
end

-- Removes the specified command from the Far's command history.
-- Returns true iff the command was found and removed
local function removeCommandFromHistory(commandToRemove)
    -- There is no plugin API for removing entries from a history.
    -- Hence we do it by simulating key presses.
    Keys("AltF8") -- Call the inbuilt command history dialog. The cursor is positioned at the last entry.

    local trimmedCmd = trim(commandToRemove) -- The command may contain spaces at the end
    local itemPos = Menu.Select(trimmedCmd) -- Try to select the item to be deleted
    local found = (itemPos > 0)
    if found then
        Keys("ShiftDel") -- Delete the current item
    end
    Keys("Esc") -- Hide the history
    return found
end


-- Removes the currently selected command from the Far's command history
-- and from our menu. Returns the index of the item that should be active
-- after removal.
local function removeCurrentCommandFromHistory(pMenuItems, curIndex)
    local curItem = pMenuItems[curIndex]
    local curCmd = curItem.command
    local removed = removeCommandFromHistory(curCmd)
    if removed then
        -- Remove the command from our menu as well
        table.remove(pMenuItems, curIndex)
    end
    return #pMenuItems < curIndex and #pMenuItems or curIndex
end


local function showMenuAndExecCommand(menuItems, menuTitle, settings)
    local sortState = settings.sortState
    local menuProps = {
        Bottom = "Ctrl+F1 - Display help",
        SelectIndex = #menuItems
    }

    resortMenuByField(menuItems, menuProps.SelectIndex, sortState.sortField, sortState, false)

    local execCommand = true
    local useSeparateWindow = false
    local breakKeys = {
        { BreakKey = "RETURN", leave = true, shortcutName = "Enter", descr = "Execute the selected command" },
        { BreakKey = "S+RETURN", action = function() useSeparateWindow = true; return menuProps.SelectIndex end, leave = true, shortcutName = "Shift+Enter", descr = "Execute the selected command in a separate window" },
        { BreakKey = "C+RETURN", action = function() execCommand = false; return menuProps.SelectIndex end, leave = true, shortcutName = "Ctrl+Enter", descr = "Put the selected command to the command line (but do not execute it)" },
        { BreakKey = "C+F3", action = function() return resortMenuByField(menuItems, menuProps.SelectIndex, "command", sortState, true) end, shortcutName = "Ctrl+F3", descr = "Sort entries by the command text" },
        { BreakKey = "C+F4", action = function() return resortMenuByField(menuItems, menuProps.SelectIndex, "execTime", sortState, true) end, shortcutName = "Ctrl+F4", descr = "Sort entries by the command execution time" },
        { BreakKey = "DELETE", action = function() return removeCurrentCommandFromHistory(menuItems, menuProps.SelectIndex) end, shortcutName = "Del", descr = "Remove the selected command from history" },
    }
    local helpText = getShortcutsDescription(breakKeys)
    table.insert(breakKeys, { BreakKey = "C+F1", action = function() far.Message(helpText, "Keyboard reference", nil, "l") end })
    local selectedItem
    repeat
        local sortDescr = getSortingDescription(sortState)
        menuProps.Title = "[ "..getSortingDescription(sortState).." ] "..menuTitle
        selectedItem, menuProps.SelectIndex = far.Menu(menuProps, menuItems, breakKeys)
        if selectedItem then
            if selectedItem.action then
                menuProps.SelectIndex = selectedItem:action()
            end
        end
    until not selectedItem or selectedItem.leave
    if selectedItem then
        print(menuItems[menuProps.SelectIndex].command)
        if execCommand then
			local execKey = useSeparateWindow and "ShiftEnter" or "Enter"
            Keys(execKey) -- The selection was made by Enter (not Ctrl+Enter) --> launch the command
        end
    end
end


local function loadSettings()
    local settings = mf.mload("CmdsFromCurDir", "settings")
    if settings == nil then
        settings = {}
    end

    local sortState = settings.sortState
    if sortState == nil then
        sortState = { sortField = "execTime", command = true, execTime = false }
        settings.sortState = sortState
    end
    return settings
end


local function saveSettings(settings)
    mf.msave("CmdsFromCurDir", "settings", settings)
end


local function commandHistoryFromCurDir()
    local settings = far.CreateSettings("far")
    local historyItems = settings:Enum("FSSF_HISTORY_CMD")
    settings:Free()

    local curDir = far.GetCurrentDirectory()

    -- Create an array of items. Each item represents a command
    -- that has been launched from the current directory.
    local menuItems = {}
    local menuItemCnt = 0

    for historyItemIdx = 1, #historyItems do
        local historyItem = historyItems[historyItemIdx]
        local param = historyItem["Param"]
        if param == curDir then
            local cmd = historyItem["Name"]
            local menuItem = {text = cmd, command = cmd, execTime = historyItem["Time"], id = historyItem["Id"]}
            menuItemCnt = menuItemCnt + 1
            menuItems[menuItemCnt] = menuItem
        end
    end

    if menuItemCnt > 0 then
        -- There are commands found --> display the menu
        local settings = loadSettings()
        showMenuAndExecCommand(menuItems, "Commands launched from "..curDir, settings)
        saveSettings(settings)
    else
        far.Message("No commands launched from '"..curDir.."' have been found in the history")
    end
end

Macro {
    description = "Display commands that have been launched from the current directory";
    area = "Shell";
    key = "CtrlShiftF8";
    action = commandHistoryFromCurDir;
}
