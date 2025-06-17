local _dir_ = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])") or "./"
package.path = _dir_ .. "?.lua"

kat = require("kat")
liluat = require("liluat")
ftcsv = require("ftcsv")

function tpl(t)
    local ct = liluat.compile(t, { start_tag = "{%", end_tag = "%}" })
    return function(values)
        return liluat.render(ct, values)
    end
end

function string.split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

components = {}
local base_font = "Monaspace Krypton"

local formats = {
  h1 = string.format("%s:bold:size=16", base_font),
  font = "${font %s}%s$font",
  item = "${color grey}%s:$color",
}

local font_formats = {
  h1 = "not_nil",
}

function conky_fmt(trigger, ...)
  text = table.concat({...}, " ")
  if font_formats[trigger] ~= nil then
    return conky_parse(string.format(formats.font, formats[trigger], text))
  else
    return conky_parse(string.format(formats[trigger], text))
  end
end

function cpu_model()
  return string.format([=[${execi %i grep model /proc/cpuinfo | cut -d : -f2 | tail -1 | sed 's/\s//' | sed 's/ [[:digit:]]*-Core Processor$//g'}]=], kat.exec_interval)
end

function cpu_sct()
    return string.format("${execi %i %scpu_sct.sh}", kat.exec_interval, kat.root_dir)
end


function conky_mem_section()
  local mem_tpl = tpl([[
    ${lua fmt h1 RAM} ${hr}

    ${color grey}Usage:$color $mem/$memmax - $memperc% ${membar 4}
    ${color grey}Easy-to-free:$color ${memeasyfree}
  ]])
end

function conky_storage_section()
end

function conky_cpu_section()
  local cpu_tpl = tpl([[
${lua fmt h1 CPU} ${hr}
${color grey}Variety:$color {%= cpu_model() %} {%= cpu_sct() %}
${cpugraph}
${color grey}Frequency:$color ${freq_g} GHz
${color grey}Usage:$color $cpu% ${cpubar 4}
]])
  return conky_parse(cpu_tpl({ cpu_model = cpu_model, cpu_sct = cpu_sct }))
end

function gpu_query(query)
  return string.format([[${execi %i nvidia-smi --query-gpu=%s --format=csv,noheader | sed 's/\d*\s\%%//' }]], 15, query)
end

-- GPU Query
local query_headers = {
  "index",
  "name",
  "driver_version",
  "fan.speed",
  "utilization.gpu",
  "utilization.memory",
  "memory.used",
  "clocks.current.graphics",
  "clocks.current.memory",
  "temperature.gpu",
  "clocks.current.sm",
  "clocks.current.video",
  "memory.total",
  "utilization.encoder",
  "utilization.decoder",
}
local gpu_display_templates = {
  index = "${lua fmt h1 GPU %s} ${hr}",
  default = "${lua fmt item %s} %s",
  hasbar = "${lua fmt item %s} %s ${nvidiabar %s %s}",
}
local gpu_header_aliases = {
  ["name"] = "Card",
  ["driver_version"] = "Driver Version",
  ["fan.speed"] = "Fan Speed",
  ["utilization.gpu"] = "Core Usage",
  ["utilization.memory"] = "Memory Usage",
  ["utilization.encoder"] = "Encoder Usage",
  ["utilization.decoder"] = "Decoder Usage",
  ["clocks.current.graphics"] = "Core Frequency",
  ["clocks.current.sm"] = "SM Frequency",
  ["clocks.current.memory"] = "Memory Frequency",
  ["clocks.current.video"] = "Video Frequency",
  ["memory.used"] = "Memory Used",
  ["memory.total"] = "Memory Total",
  ["temperature.gpu"] = "Temperature",
};
local gpu_header_to_nvidiabar = {
  --[[["fan.speed"] = "fanlevel",
  ["utilization.gpu"] = "gpuutil",
  ["utilization.memory"] = "memutil",
  ["clocks.current.graphics"] = "gpufreq",
  ["clocks.current.memory"] = "memfreq",
  ["temperature.gpu"] = "temp",
  ["memory.used"] = "mem",]]--
};
-- Reverse index
local query_headers_index = {}
for i, header in ipairs(query_headers) do
  query_headers_index[header] = i
end
-- Command generation caching
local query_header_string = table.concat(query_headers, ",")
local query_command = string.format("nvidia-smi --query-gpu=%s --format=csv,nounits", query_header_string)
local headers = nil
function gpu_csv_query()
  local gpus = {}
  local query_ran = io.popen(query_command)
  local query = query_ran:read("*all")
  local query = query:gsub(",%s", ",")
  local items, raw_headers = ftcsv.parse(query, {
    loadFromString = true,
  })
  if headers == nil then
      headers = {}
    for i, heading in ipairs(raw_headers) do
      local heading_split = string.split(heading)
      local query_unit
      local key = heading_split[1]
      -- if the heading does not have a [unit] section
      if #heading_split == 1 then
        -- use a table to define what the key's unit should be
        local keys_to_units = {
          ["temperature.gpu"] = "°C",
          index = nil,
          driver_version = nil,
          name = nil,
        }
        -- give it a unit
        query_unit = keys_to_units[key]
      else
          query_unit = string.sub(heading_split[2], 2, -2)
          local unit_remap = {
            MiB = " MiB"
          }
          if unit_remap[query_unit] ~= nil then
            query_unit = unit_remap[query_unit]
          end
      end
      headers[heading] = {
          clean = key,
          unit = query_unit
        }
    end
  end

  for i, gpu in pairs(items) do
    current_gpu = {}
    for header, data in pairs(gpu) do
      local cur_header = headers[header]

      local subformat = "%s%s"
      local unit = cur_header.unit or ""
      data_sf = string.format(subformat, data, unit)


      local display_idx = query_headers_index[cur_header.clean] or 500
      if gpu_display_templates[cur_header.clean] ~= nil then
        display = string.format(gpu_display_templates[cur_header.clean], data_sf)
      else
        if gpu_header_to_nvidiabar[cur_header.clean] ~= nil then
          local nvidiabar = gpu_header_to_nvidiabar[cur_header.clean]
          display = string.format(gpu_display_templates.hasbar, gpu_header_aliases[cur_header.clean], data_sf, nvidiabar, i)
        else
            display = string.format(gpu_display_templates.default, gpu_header_aliases[cur_header.clean], data_sf)
        end
      end
      current_gpu[display_idx] = display
    end
    gpus[i] = current_gpu
  end

  return gpus
end

-- GPU Display
function conky_gpu_section()
  gpus = gpu_csv_query()
  local text = ""
  for idx, gpu in pairs(gpus) do
    for i=1,#gpu do
      text = text .. string.format("%s\n", gpu[i])
    end
  end
  return conky_parse(text)
end

return components
