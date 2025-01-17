-- Author : https://gist.github.com/liukun
-- Link : https://gist.github.com/liukun/f9ce7d6d14fa45fe9b924a3eed5c3d99

function char_to_hex(c)
  return string.format("%%%02X", string.byte(c))
end

function url_encode(url)
  if url == nil then
    return
  end
  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^%w ])", char_to_hex)
  url = url:gsub(" ", "+")
  return url
end

function hex_to_char(x)
  return string.char(tonumber(x, 16))
end

function url_decode(url)
  if url == nil then
    return
  end
  url = url:gsub("+", " ")
  url = url:gsub("%%(%x%x)", hex_to_char)
  return url
end

-- ref: https://gist.github.com/ignisdesign/4323051
-- ref: http://stackoverflow.com/questions/20282054/how-to-urldecode-a-request-uri-string-in-lua
-- to encode table as parameters, see https://github.com/stuartpb/tvtropes-lua/blob/master/urlencode.lua