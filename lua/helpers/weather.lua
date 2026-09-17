local M = {
    cache_expired = 60 * 30,
    is_cache_updating = false,
    cache2 = nil,
}

--- Convert weather code into symbol
---
--- @param code any
local function convert_weather_code(code)
    local hour = os.date("*t").hour
    local is_day = hour >= 6 and hour < 18
    local icons = {
        -- Clear / Sunny
        [113] = is_day and "󰖙" or "󰖔",

        -- Partly cloudy
        [116] = is_day and "󰖕" or "󰼱",

        -- Cloudy
        [119] = "󰖐",
        [122] = "󰖐",

        -- Mist / Fog
        [143] = "󰖑",
        [248] = "󰖑",
        [260] = "󰖑",

        -- Rain
        [176] = "󰖗",
        [263] = "󰖗",
        [266] = "󰖖",
        [293] = "󰖖",
        [296] = "󰖖",
        [299] = "󰖖",
        [302] = "󰖖",
        [305] = "󰖖",
        [308] = "󰖖",
        [311] = "󰖖",
        [314] = "󰖖",
        [353] = "󰖖",
        [356] = "󰖖",
        [359] = "󰖖",

        -- Snow
        [179] = "󰼶",
        [227] = "󰼶",
        [230] = "󰼶",
        [323] = "󰼶",
        [326] = "󰼶",
        [329] = "󰼶",
        [332] = "󰼶",
        [335] = "󰼶",
        [338] = "󰼶",
        [368] = "󰼶",
        [371] = "󰼶",
        [392] = "󰼶",
        [395] = "󰼶",

        -- Thunderstorm
        [200] = "󰖓",
        [386] = "󰖓",
        [389] = "󰖓",

        -- Sleet
        [182] = "󰙿",
        [185] = "󰙿",
        [281] = "󰙿",
        [284] = "󰙿",
        [317] = "󰙿",
        [320] = "󰙿",
        [350] = "󰙿",
        [362] = "󰙿",
        [365] = "󰙿",
        [374] = "󰙿",
        [377] = "󰙿",
    }

    code = tonumber(code)
    return icons[code] or "󰖐"
end

local function convert_wind_degree(degree)
    local directions = {
        "󰁅",
        "󰁂",
        "󰁍",
        "󰁛",
        "󰁝",
        "󰁜",
        "󰁔",
        "󰁃",
    }
    local index = math.floor(degree / 45) % 8 + 1
    return directions[index]
end

--- Parse response from wttr.in
---
--- @param response vim.net.request.Response
--- @return table
local function parse_response(response)
    local body = vim.json.decode(response.body)
    local info = body["current_condition"][1]
    return {
        weather_code = info.weatherCode,
        actual_temp = info.temp_C,
        feels_temp = info.FeelsLikeC,
        wind_degree = info.winddirDegree,
        wind_speed = info.windspeedKmph,
    }
end

--- Path to cache file
---
--- @return string
local function cache_path()
    return vim.fs.joinpath(vim.fn.stdpath("cache"), "weather-cache")
end

--- Write new weather info into cache
---
--- @param info table
--- @param at integer
local function write_cache(info, at)
    local path = cache_path()
    local file = io.open(path, "w")
    if not file then
        error("failed to write cache")
    end
    file:write(vim.json.encode {
        info = info,
        at = at,
    })
    file:close()
end

--- Get cached weather info, or initial value if not exists
---
--- @return table, integer
local function read_cache()
    local path = cache_path()
    local file = io.open(path, "r")
    if not file then
        local init_info = {
            weather_code = 0,
            actual_temp = 0,
            feels_temp = 0,
            wind_degree = 0,
            wind_speed = 0,
        }
        return init_info, 0
    end
    local cache = vim.json.decode(file:read("*a"))
    file:close()
    return cache["info"], cache["at"]
end

--- Update cache asynchronously
local function update_cache()
    M.is_cache_updating = true
    vim.net.request("https://wttr.in?format=j2", {}, function(err, response)
        if err then
            error(err)
        end
        local info = parse_response(response)
        local at = os.time()
        write_cache(info, at)
        M.cache2 = { info = info, at = at }
        M.is_cache_updating = false
    end)
end

--- Initialize/Update cache
function M.__load_cache()
    if M.cache2 == nil then
        local info, at = read_cache()
        M.cache2 = {
            info = info,
            at = at,
        }
    end
    local now = os.time()
    if M.cache2.at + M.cache_expired < now and not M.is_cache_updating then
        update_cache()
    end
end

--- Get weather info usable for statusline
---
--- @return string
function M.get_status()
    M.__load_cache()
    local info = M.cache2.info
    return string.format(
        "%s  +%s(%s)° %s%skm/h",
        convert_weather_code(info.weather_code),
        info.actual_temp,
        info.feels_temp,
        convert_wind_degree(info.wind_degree),
        info.wind_speed
    )
end

return M
