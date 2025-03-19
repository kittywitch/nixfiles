local _dir_ = debug.getinfo(1, "S").source:sub(2):match("(.*[/\\])") or "./"

kat = { root_dir = _dir_, exec_interval = 3600 }

return kat
