local function updateStatus()
    SetTimeout(10 * 60000, updateStatus)
end

updateStatus()