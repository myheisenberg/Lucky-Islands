-- ============================================================
--  Zynex Hub | Lucky Islands Edition (KEYLESS)
--  Game: Lucky Islands (18134283205)
--  Developer: ZynexDev
-- ============================================================

local VSS_URL = "https://vault.pandauth.com/vss/88318421633d394f"

local function IsValidLuaScript(content)
    if type(content) ~= "string" or #content < 100 then return false end
    local head = content:sub(1, 300):lower()
    if head:find("<!doctype") or head:find("<html") or head:find("<head") or head:find("<title>") or head:find("blocked") then
        return false
    end
    return true
end

local function SafeFetch(url)
    local content = nil
    local req = request or http_request or (syn and syn.request) or (http and http.request)
    if req then
        for _, ua in ipairs({ "Roblox/WinInet", "Roblox/Android" }) do
            pcall(function()
                local res = req({
                    Url = url,
                    url = url,
                    Method = "GET",
                    method = "GET",
                    Headers = { ["User-Agent"] = ua, ["user-agent"] = ua, ["Accept"] = "*/*" },
                    headers = { ["User-Agent"] = ua, ["user-agent"] = ua, ["Accept"] = "*/*" }
                })
                if res and (res.Body or res.body) then
                    local b = res.Body or res.body
                    if IsValidLuaScript(b) then content = b end
                end
            end)
            if content then return content end
        end
    end

    pcall(function()
        local b = game:HttpGetAsync(url)
        if IsValidLuaScript(b) then content = b end
    end)
    if content then return content end

    pcall(function()
        local b = game:HttpGet(url)
        if IsValidLuaScript(b) then content = b end
    end)
    if content then return content end

    return nil
end

local src = SafeFetch(VSS_URL)
if not src then
    warn("[Zynex Hub | Lucky Islands] Failed to fetch script payload from Panda Vault.")
    return
end

local fn, err = loadstring(src)
if not fn then
    warn("[Zynex Hub | Lucky Islands] Load error: " .. tostring(err))
    return
end

fn()
