--ToLua  

function table.clone(tb) 
    local temp = {}
    local function copy(tb)
        if type(tb)~="table" then return tb end
        if temp[tb] then return temp[tb] end
        local newtb = {}
        temp[tb] = newtb

        for k,v in pairs(tb) do 
            newtb[copy(k)] = copy(v)
        end
        setmetatable(newtb, getmetatable(tb))
        return newtb
    end
    return copy(tb)    
end