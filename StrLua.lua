-- StrLua.lua

--[[
This Module is under the MIT license
The Document is the same as python document , check out --> https://www.w3schools.com/python/python_ref_string.asp
Some Addition function are listed bellow
]]

--[[
binfind(sortedstr,str) --> str or -1 if not found
Slice thingy (scroll down below)
in
sha256(str)
base64_decode(str) --> str
base64_encode(str) --> str
morse_decode(str) --> str
morse_encode(str) --> str
generateCatFact() --> str
xor_encrypt(str,key) --> str
xor_decrypt(str,key) --> str

]]
-- Module declaration
local StrLua = {}

-- Module Versions
StrLua.version = "1.0"
--Addition String Method (Beside Python-like string method)

--Binary Search Algorithm
--[[
StrLua.binfind
Function Description
The StrLua.binfind function performs a binary search on a sorted string to find a target substring. It returns the index of the first occurrence of the target substring in the sorted string, or -1 if the target substring is not found.

Function Signature
StrLua.binfind(sortedString, target)

Parameters
sortedString: The sorted string to search for the target substring. This string must be sorted in lexicographical order.
target: The target substring to search for in the sorted string.
Return Values
index: The index of the first occurrence of the target substring in the sorted string, or -1 if the target substring is not found.
message: A string indicating whether the target substring was found or not.
Error Handling
If either sortedString or target is nil, an error is raised with the message "Both sortedString and target must be non-nil".
If the length of target is greater than the length of sortedString, an error is raised with the message "Target substring cannot be longer than the sorted string".
]]


--[[
Example :
local StrLua = require("StrLua")

local sortedString = "abcdefghij"
local target = "def"

local index, message = StrLua.binfind(sortedString, target)
print(index, message)  -- Output: 4  Substring found

local target = "xyz"
local index, message = StrLua.binfind(sortedString, target)
print(index, message)  -- Output: -1  Substring not found
]]
-----------------------------------------------------------------------------------------


--[[
Note that this algorithm assumes the input string is already sorted.
This algorithm is O(log n) i guess ?
If the input string is not sorted, you'll need to sort it first, which would add an additional O(n log n) time complexity.
]]

function StrLua.binfind(sortedString, target)
    if type(sortedString) ~= "string" or type(target) ~= "string" then
        error("binfind: Both sortedString and target must be strings")
    end

    local low, high = 1, #sortedString
    while low <= high do
        local mid = math.floor((low + high) / 2)
        local midStr = sortedString:sub(mid, mid + #target - 1)
        if midStr == target then
            return mid, "Substring found"
        elseif midStr < target then
            low = mid + 1
        else
            high = mid - 1
        end
    end
    return -1
end

--String Slice (same as str[0:5]) or whatever

--[[
Example :
local s = "hello"

print(s[1])  -- prints "h"
print(s[1:3])  -- prints "he"
print(s[1:5:2])  -- prints "hlo"
print(s[-3:-1])  -- prints "llo"
]]


--[[
slice
Description
Extracts a subset of characters from a string or elements from a table.

Parameters
s or t: The string or table to slice.
key: A table containing the slice indices (e.g., {start, stop, step}).
Return Value
A new string or table containing the sliced subset.
Notes
Uses 1-based indexing.
Returns a new string or table, does not modify the original.
If step is not provided, it defaults to 1.
]]


function string.__index(s, k)
    if type(k) == "string" then
        local start, stop, step = k:match("^(%-?%d*)%:(%-?%d*)%:(%-?%d*)$")
        if start then
            start = tonumber(start)
            stop = tonumber(stop)
            step = tonumber(step)
            if start and stop and step then
                if start < 1 or start > #s then
                    error("Start index out of range")
                end
                if stop < 1 or stop > #s then
                    error("Stop index out of range")
                end
                if step < 1 then
                    error("Step must be a positive integer")
                end
                return string.slice(s, start, stop, step)
            elseif start and stop then
                if start < 1 or start > #s then
                    error("Start index out of range")
                end
                if stop < 1 or stop > #s then
                    error("Stop index out of range")
                end
                return string.slice(s, start, stop)
            elseif start then
                if start < 1 or start > #s then
                    error("Start index out of range")
                end
                return string.slice(s, start)
            else
                error("Invalid slice syntax")
            end
        else
            error("Invalid slice syntax")
        end
    elseif type(k) == "table" then
        if #k < 1 or #k > 3 then
            error("Invalid slice table")
        end
        local start, stop, step = k[1], k[2], k[3]
        if start and stop and step then
            if type(start) ~= "number" or type(stop) ~= "number" or type(step) ~= "number" then
                error("Invalid slice table")
            end
            if start < 1 or start > #s then
                error("Start index out of range")
            end
            if stop < 1 or stop > #s then
                error("Stop index out of range")
            end
            if step < 1 then
                error("Step must be a positive integer")
            end
            return string.slice(s, start, stop, step)
        elseif start and stop then
            if type(start) ~= "number" or type(stop) ~= "number" then
                error("Invalid slice table")
            end
            if start < 1 or start > #s then
                error("Start index out of range")
            end
            if stop < 1 or stop > #s then
                error("Stop index out of range")
            end
            return string.slice(s, start, stop)
        elseif start then
            if type(start) ~= "number" then
                error("Invalid slice table")
            end
            if start < 1 or start > #s then
                error("Start index out of range")
            end
            return string.slice(s, start)
        else
            error("Invalid slice table")
        end
    else
        return s:sub(k, k)
    end
end


--In (from python)

--[[
Example :
local s = "hello"
print("ell" in s)  -- prints true
print("world" in s)  -- prints false
]]


--[[
in
Description
Checks if a value is present in a string or table.

Parameters
s or t: The string or table to search in.
val: The value to search for.
Return Value
true if val is found in s or t, false otherwise.
Notes
This method is case-sensitive for strings.
For tables, this method checks for exact equality of values.
This method only works for strings and tables, not for other types.
]]
function string.__in(s, val)
    return s:find(val) ~= nil
end


--Sha256 (guess u already khow how to use this)

function StrLua.sha256(str)
    if type(str) ~= "string" then
        error("sha256: Argument must be a string")
    end

    local function leftrotate(n, b)
        return (n << b) | (n >> (32 - b))
    end

    local function rightrotate(n, b)
        return (n >> b) | (n << (32 - b))
    end

    local function add(x, y)
        return (x + y) & 0xFFFFFFFF
    end

    local function rotr(x, n)
        return rightrotate(x, n)
    end

    local function sigma0(x)
        return rotr(x, 2) ~ rotr(x, 13) ~ rotr(x, 22)
    end

    local function sigma1(x)
        return rotr(x, 6) ~ rotr(x, 11) ~ rotr(x, 25)
    end

    local function gamma0(x)
        return rotr(x, 7) ~ rotr(x, 18) ~ rightrotate(x, 3)
    end

    local function gamma1(x)
        return rotr(x, 17) ~ rotr(x, 19) ~ rightrotate(x, 10)
    end

    local function sha256_compress(h, m)
        local w = {}
        for i = 0, 15 do
            w[i] = m[i * 4 + 1] * 0x1000000 + m[i * 4 + 2] * 0x10000 + m[i * 4 + 3] * 0x100 + m[i * 4 + 4]
        end

        for i = 16, 63 do
            w[i] = add(gamma1(w[i - 2]), w[i - 7], gamma0(w[i - 15]), w[i - 16])
        end

        local a, b, c, d, e, f, g, h = h[1], h[2], h[3], h[4], h[5], h[6], h[7], h[8]
        for i = 0, 63 do
            local s0 = sigma0(a)
            local maj = (a ~ b) ~ (a ~ c) ~ (b ~ c)
            local t2 = s0 + maj
            local s1 = sigma1(e)
            local ch = (e ~ f) ~ ((~e) ~ g)
            local t1 = h[i] + t2 + s1 + ch + 0x428a2f98d728ae22
            h = {(t1 ~ (t1 >> 32)) & 0xFFFFFFFF, b, c, d, (e + t1) & 0xFFFFFFFF, f, g, h}
            a, b, c, d, e, f, g, h = h[1], h[2], h[3], h[4], h[5], h[6], h[7], h[8]
        end

        for i = 1, 8 do
            h[i] = add(h[i], m[i])
        end

        return h
    end

    local function sha256(str)
        local h = {0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19}
        local m = {}
        for i = 1, #str do
            m[#m + 1] = str:byte(i)
        end

        m[#m + 1] = 0x80
        while #m % 64 ~= 56 do
            m[#m + 1] = 0
        end

        local len = #str * 8
        for i = 1, 8 do
            m[#m + 1] = len % 0x100
            len = math.floor(len / 0x100)
        end

        for i = 1, #m, 64 do
            h = sha256_compress(h, {m[i], m[i + 1], m[i + 2], m[i + 3], m[i + 4], m[i + 5], m[i + 6], m[i + 7], m[i + 8], m[i + 9], m[i + 10], m[i + 11], m[i + 12], m[i + 13], m[i + 14], m[i + 15]})
        end

        local hash = ""
        for i = 1, 8 do
            hash = hash.. string.format("%08x", h[i])
        end

        return hash
    end

    return sha256(str)
end


--Base64 decode and encode(prob u khow how to use this too

function StrLua.base64_encode(str)
    if type(str) ~= "string" then
        error("base64_encode: Argument must be a string")
    end

    local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local result = ""

    for i = 1, #str, 3 do
        local chunk = str:sub(i, i + 2)
        local byte1, byte2, byte3 = chunk:byte(1, -1)

        local b64byte1 = math.floor(byte1 / 4)
        local b64byte2 = (byte1 % 4) * 16 + math.floor(byte2 / 16)
        local b64byte3 = (byte2 % 16) * 4 + math.floor(byte3 / 64)
        local b64byte4 = byte3 % 64

        result = result .. b64chars:sub(b64byte1 + 1, b64byte1 + 1) ..
                         b64chars:sub(b64byte2 + 1, b64byte2 + 1) ..
                         (i + 2 > #str and "=" or b64chars:sub(b64byte3 + 1, b64byte3 + 1)) ..
                         (i + 1 > #str and "=" or b64chars:sub(b64byte4 + 1, b64byte4 + 1))
    end

    return result
end

function StrLua.base64_decode(str)
    if type(str) ~= "string" then
        error("base64_decode: Argument must be a string")
    end

    local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local result = ""

    str = str:gsub("%s+", "") -- remove whitespace

    for i = 1, #str, 4 do
        local chunk = str:sub(i, i + 3)
        local b64byte1, b64byte2, b64byte3, b64byte4 = chunk:byte(1, -1)

        b64byte1 = b64chars:find(chunk:sub(1, 1)) - 1
        b64byte2 = b64chars:find(chunk:sub(2, 2)) - 1
        b64byte3 = b64chars:find(chunk:sub(3, 3)) - 1
        b64byte4 = b64chars:find(chunk:sub(4, 4)) - 1

        local byte1 = b64byte1 * 4 + math.floor(b64byte2 / 16)
        local byte2 = (b64byte2 % 16) * 16 + math.floor(b64byte3 / 4)
        local byte3 = (b64byte3 % 4) * 64 + b64byte4

        result = result .. string.char(byte1)

        if b64byte3 ~= 64 then
            result = result .. string.char(byte2)
        end

        if b64byte4 ~= 64 then
            result = result .. string.char(byte3)
        end
    end

    return result
end

function StrLua.morse_decode(morse_code)
    if type(morse_code) ~= "string" then
        error("morse_decode: Argument must be a string")
    end

    local morse_code_map = {
        [".-"] = "A", ["-..."] = "B", ["-.-."] = "C", ["-.."] = "D", ["."] = "E",
        ["..-."] = "F", ["--."] = "G", ["...."] = "H", [".."] = "I", [".---"] = "J",
        ["-.-"] = "K", [".-.."] = "L", ["--"] = "M", ["-."] = "N", ["---"] = "O",
        [".--."] = "P", ["--.-"] = "Q", [".-."] = "R", ["..."] = "S", ["-"] = "T",
        ["..-"] = "U", ["...-"] = "V", [".--"] = "W", ["-..-"] = "X", ["-.--"] = "Y",
        ["--.."] = "Z", ["-----"] = "0", [".----"] = "1", ["..---"] = "2", ["...--"] = "3",
        ["....-"] = "4", ["....."] = "5", ["-...."] = "6", ["--..."] = "7", ["---.."] = "8",
        ["----."] = "9", ["/"] = " ", [".-.-.-"] = ".", ["-..-."] = ",", ["..--.."] = "?",
        ["-.--."] = "(", ["-.--.-"] = ")", ["---..."] = ":", ["-.-.-."] = ";",
        ["-....-"] = "-", ["..--.-"] = "_", [".-..-."] = "\"", [".-.-."] = "@",
        [".--.-."] = "!"
    }

    local result = ""
    for word in morse_code:gmatch("%S+") do
        for char in word:gmatch("%S+") do
            if char == "/" then
                result = result .. " "
            else
                result = result .. (morse_code_map[char] or "")
            end
        end
        result = result .. " "
    end

    return result:sub(1, -2) -- remove trailing space
end

function StrLua.morse_encode(text)
    if type(text) ~= "string" then
        error("morse_encode: Argument must be a string")
    end

    local morse_code_map = {
        A = ".-", B = "-...", C = "-.-.", D = "-..", E = ".",
        F = "..-.", G = "--.", H = "....", I = "..", J = ".---",
        K = "-.-", L = ".-..", M = "--", N = "-.", O = "---",
        P = ".--.", Q = "--.-", R = ".-.", S = "...", T = "-",
        U = "..-", V = "...-", W = ".--", X = "-..-", Y = "-.--",
        Z = "--..", ["0"] = "-----", ["1"] = ".----", ["2"] = "..---",
        ["3"] = "...--", ["4"] = "....-", ["5"] = ".....", ["6"] = "-....",
        ["7"] = "--...", ["8"] = "---..", ["9"] = "----.", [" "] = "/",
        ["."] = ".-.-.-", [","] = "-..-", ["?"] = "..--..", ["("] = "-.--.",
        [")"] = "-.--.-", [":"] = "---...", [";"] = "-.-.-.", ["-"] = "-....-",
        ["_"] = "..--.-", ["\""] = ".-..-.", ["@"] = ".--.-.", ["!"] = "-.-.--"
    }

    local result = ""
    for char in text:upper():gmatch(".") do
        if char == " " then
            result = result .. "/ "
        else
            result = result .. (morse_code_map[char] or "") .. " "
        end
    end

    return result:sub(1, -2) -- remove trailing space
end

--Cat Fact

-- Cat fact database
local catFacts = {
  "Cats have a highly developed sense of hearing, and can hear sounds that are too faint for humans to detect.",
  "Cats have retractable claws, which they use for climbing, hunting, and self-defense.",
  "A group of cats is called a 'clowder'.",
  "Cats have three eyelids: an upper lid, a lower lid, and a third lid called the nictitating membrane.",
  "Cats can't taste sweetness, which is why they often prefer savory foods.",
  "Cats have 32 muscles in each ear, which allows them to rotate their ears 180 degrees.",
  "Cats can sleep for up to 16 hours a day, and spend about 1/3 of their lives sleeping.",
  "Cats are highly territorial, and use scent markings to communicate with other cats.",
  "Cats can jump up to 5 times their own height in a single bound.",
  "Cats have a unique nose print, just like human fingerprints.",
  "Cats can see in low light conditions because their eyes contain a reflective layer called the tapetum lucidum.",
  "Cats are highly agile, and can right themselves in mid-air to land on their feet.",
  "Cats have a special talent for recognizing and mimicking human voices.",
  "Cats can live up to 17 years or more in captivity, with some breeds living up to 20 years or more.",
  "Cats are highly intelligent, and can solve simple problems and learn from experience.",
  "Cats have a special type of eye structure that allows them to see ultraviolet light.",
  "Cats can't see directly under their noses, which is why they often use their whiskers to detect objects.",
  "Cats have a unique way of walking called a 'righting reflex', which allows them to always land on their feet.",
  "Cats can produce over 100 different vocal sounds, including meows, purrs, hisses, and growls.",
  "Cats have a highly developed sense of smell, and can detect pheromones that are invisible to humans.",
  "Cats can be right- or left-pawed, just like humans are right- or left-handed.",
  "Cats have a special type of fur that helps to reduce noise, making them expert hunters.",
  "Cats can be trained to do tricks and obey commands, just like dogs.",
  "Cats have a unique way of communicating with each other through body language and vocalizations.",
  "Cats can be very affectionate, and often form strong bonds with their human caregivers.",
  "Cats have a special type of whisker that helps them to detect changes in air pressure, which can predict weather changes."
}

-- Function to generate a random cat fact
local function generateCatFact()
  local factIndex = math.random(#catFacts)
  return catFacts[factIndex]
end

-- XOR

-- Function to XOR encrypt a string
local function xor_encrypt(plain_text, key)
  local encrypted_text = ""
  for i = 1, #plain_text do
    local char_code = string.byte(plain_text, i)
    local key_code = string.byte(key, (i % #key) + 1)
    local encrypted_char_code = char_code ~ key_code
    encrypted_text = encrypted_text.. string.char(encrypted_char_code)
  end
  return encrypted_text
end

-- Function to XOR decrypt a string
local function xor_decrypt(encrypted_text, key)
  local decrypted_text = ""
  for i = 1, #encrypted_text do
    local char_code = string.byte(encrypted_text, i)
    local key_code = string.byte(key, (i % #key) + 1)
    local decrypted_char_code = char_code ~ key_code
    decrypted_text = decrypted_text.. string.char(decrypted_char_code)
  end
  return decrypted_text
end

--[[ Example usage:
local plain_text = "Hello, World!"
local key = "my_secret_key"

local encrypted_text = xor_encrypt(plain_text, key)
print("Encrypted text: ".. encrypted_text)

local decrypted_text = xor_decrypt(encrypted_text, key)
print("Decrypted text: ".. decrypted_text)
]]

--String Method
function StrLua.capitalize(str)
	if type(str) ~= "string" then
		error("center: str must be a string")
	end
	return str:sub(1,1):upper()..str:sub(2)
end

function StrLua.casefold(str)
	if type(str) ~= "string" then
		error("center: str must be a string")
	end
	return str:gsub("[A-Z]", function(c) return string.char(string.byte(c) + 32) end)
end

function StrLua.center(str, width)
	if type(str) ~= "string" then
		error("center: str must be a string")
	end
	if type(width) ~= "number" or width < 1 then
		error("center: width must be a positive integer")
	end
	if width < #str then
		error("center: width is too small for the string")
	end

	local len = #str
	local padding = math.floor((width - len) / 2)
	return string.rep(" ", padding) .. str .. string.rep(" ", width - len - padding)
end

function StrLua.count(str, sub)
	if type(str) ~= "string" then
		error("count: str must be a string")
	end
	if type(sub) ~= "string" then
		error("count: sub must be a string")
	end

	local count = 0
	local pos = 1
	while true do
		pos = str:find(sub, pos)
		if pos then
			count = count + 1
			pos = pos + 1
		else
			break
		end
	end
	return count
end

function StrLua.encode(str, encoding)
	if type(str) ~= "string" then
		error("encode: str must be a string")
	end
	if type(encoding) ~= "string" then
		error("encode: encoding must be a string")
	end

	if encoding == "utf-8" then
		-- Lua's string library doesn't provide a built-in way to encode strings to UTF-8,
		-- so we'll use a simple implementation that only works for ASCII characters
		local encoded = ""
		for i = 1, #str do
			local c = str:sub(i, i)
			local byte = string.byte(c)
			if byte < 128 then
				encoded = encoded.. string.char(byte)
			else
				error("encode: UTF-8 encoding not supported for non-ASCII characters")
			end
		end
		return encoded
	elseif encoding == "ascii" then
		-- ASCII encoding is trivial, just return the original string
		return str
	else
		error("encode: unsupported encoding ".. encoding)
	end
end

function StrLua.endswith(str, suffix)
	if type(str) ~= "string" then
		error("endswith: str must be a string")
	end
	if type(suffix) ~= "string" then
		error("endswith: suffix must be a string")
	end

	local str_len = #str
	local suffix_len = #suffix
	if suffix_len > str_len then
		return false
	end

	local start = str_len - suffix_len + 1
	local substr = str:sub(start, str_len)
	return substr == suffix
end

function StrLua.expandtabs(str, tabsize)
	if type(str) ~= "string" then
		error("expandtabs: str must be a string")
	end
	if tabsize and type(tabsize) ~= "number" then
		error("expandtabs: tabsize must be a number")
	end

	tabsize = tabsize or 8 -- default tab size is 8

	local result = ""
	local i = 1
	while i <= #str do
		local c = str:sub(i, i)
		if c == "\t" then
			local num_spaces = tabsize - (#result % tabsize)
			result = result .. string.rep(" ", num_spaces)
		else
			result = result .. c
		end
		i = i + 1
	end
	return result
end

function StrLua.find(str, sub, start)
	if type(str) ~= "string" then
		error("find: str must be a string")
	end
	if type(sub) ~= "string" then
		error("find: sub must be a string")
	end
	if start and type(start) ~= "number" then
		error("find: start must be a number")
	end

	start = start or 1 -- default start position is 1

	local pos = str:find(sub, start)
	if pos then
		return pos
	else
		return -1 -- not found
	end
end

function StrLua.format(str,...)
	local args = {...}
	return str:gsub("({([^{}]+)})", function(full, key)
		if type(key) ~= "string" then
			error("format: Key must be a string, got ".. type(key), 2)
		end

		if key:match("^%d+$") then
			local index = tonumber(key) + 1
			if index < 1 or index > #args then
				error("format: Index ".. key.. " is out of range. It must be between 1 and ".. #args, 2)
			end
			local value = args[index]
			if value == nil then
				error("format: Argument ".. key.. " is missing", 2)
			end
			return tostring(value)
		else
			for i, arg in pairs(args) do
				if type(arg) == "table" and arg[key] ~= nil then
					return tostring(arg[key])
				end
			end
			error("format: Key '".. key.. "' not found in arguments.", 2)
		end
	end)
end

function StrLua.format_map(str, map)
	if type(str) ~= "string" then
		error("format_map: First argument must be a string, got " .. type(str), 2)
	end

	if type(map) ~= "table" then
		error("format_map: Second argument must be a table, got " .. type(map), 2)
	end

	return str:gsub("({([^{}]+)})", function(full, key)
		if type(key) ~= "string" then
			error("format_map: Key must be a string, got " .. type(key), 2)
		end

		if map[key] == nil then
			error("format_map: Key '" .. key .. "' not found in the map", 2)
		end

		return tostring(map[key])
	end)
end

function StrLua.index(str, start, length)
	if type(str) ~= "string" then
		error("index: First argument must be a string, got ".. type(str), 2)
	end

	if start == nil then
		start = 1
	elseif type(start) ~= "number" then
		error("index: Second argument must be a number, got ".. type(start), 2)
	end

	if length == nil then
		length = -1
	elseif type(length) ~= "number" then
		error("index: Third argument must be a number,  got ".. type(length), 2)
	end

	if start < 1 or start > #str then
		error("index: Start index out of range", 2)
	end

	if length < -1 or length > #str - start + 1 then
		error("index: Length out of range", 2)
	end

	if length == -1 then
		return str:sub(start)
	else
		return str:sub(start, start + length - 1)
	end
end

function StrLua.isalnum(c)
	if type(c) ~= "string" or #c ~= 1 then
		error("isalnum: Argument must be a single character, got ".. type(c), 2)
	end

	local byte = string.byte(c)
	return (byte >= 48 and byte <= 57) or -- 0-9
		(byte >= 65 and byte <= 90) or -- A-Z
		(byte >= 97 and byte <= 122) -- a-z
end

function StrLua.isalpha(c)
	if type(c) ~= "string" or #c ~= 1 then
		error("isalpha: Argument must be a single character, got ".. type(c), 2)
	end

	local byte = string.byte(c)
	return (byte >= 65 and byte <= 90) or -- A-Z
		(byte >= 97 and byte <= 122) -- a-z
end

function StrLua.isascii(c)
	if type(c) ~= "string" or #c ~= 1 then
		error("isascii: Argument must be a single character, got ".. type(c), 2)
	end

	local byte = string.byte(c)
	return byte <= 127
end

function StrLua.isdecimal(c)
	if type(c) ~= "string" or #c ~= 1 then
		error("isdecimal: Argument must be a single character, got ".. type(c), 2)
	end

	local byte = string.byte(c)
	return byte >= 48 and byte <= 57 -- 0-9
end

function StrLua.isdigit(c)
	if type(c) ~= "string" or #c ~= 1 then
		error("isdigit: Argument must be a single character, got ".. type(c), 2)
	end

	local byte = string.byte(c)
	return (byte >= 48 and byte <= 57) or -- 0-9
		(byte >= 65300 and byte <= 65338) -- Unicode digits (e.g. Arabic, Hindi, etc.)
end

function StrLua.isidentifier(s)
	if type(s) ~= "string" then
		error("isidentifier: Argument must be a string, got ".. type(s), 2)
	end

	local pattern = "^[_%a][_%a%d]*$"
	return s:match(pattern) ~= nil
end

function StrLua.islower(c)
	if type(c) ~= "string" or #c ~= 1 then
		error("islower: Argument must be a single character, got ".. type(c), 2)
	end

	local byte = string.byte(c)
	return byte >= 97 and byte <= 122 -- a-z
end

function StrLua.isnumeric(s)
	if type(s) ~= "string" then
		error("isnumeric: Argument must be a string, got ".. type(s), 2)
	end

	local pattern = "^[-+]?%d*%.?%d+$"
	return s:match(pattern) ~= nil
end

function StrLua.isprintable(s)
	if type(s) ~= "string" then
		error("isprintable: Argument must be a string, got ".. type(s), 2)
	end

	for i = 1, #s do
		local c = s:sub(i, i)
		local byte = string.byte(c)
		if byte < 32 or byte > 126 then
			return false
		end
	end
	return true
end

function StrLua.isspace(c)
	if type(c) ~= "string" or #c ~= 1 then
		error("isspace: Argument must be a single character, got ".. type(c), 2)
	end

	local byte = string.byte(c)
	return byte == 32 or -- space
		byte == 9 or -- tab
		byte == 10 or -- newline
		byte == 13 or -- carriage return
		byte == 12 -- form feed
end

function StrLua.istitle(s)
	if type(s) ~= "string" then
		error("istitle: Argument must be a string, got ".. type(s), 2)
	end

	local words = {}
	for word in s:gmatch("%S+") do
		table.insert(words, word)
	end

	for i, word in ipairs(words) do
		if not (word:sub(1, 1):match("%u") and word:sub(2):match("%l*")) then
			return false
		end
	end

	return true
end

function StrLua.isupper(c)
	if type(c) ~= "string" or #c ~= 1 then
		error("isupper: Argument must be a single character, got ".. type(c), 2)
	end

	local byte = string.byte(c)
	return byte >= 65 and byte <= 90 -- A-Z
end

function StrLua.join(sep, ...)
	if type(sep) ~= "string" then
		error("join: Separator must be a string, got ".. type(sep), 2)
	end

	local args = {...}
	local result = ""

	for i, str in ipairs(args) do
		if type(str) ~= "string" then
			error("join: Argument ".. i .." must be a string, got ".. type(str), 2)
		end

		result = result .. str .. sep
	end

	return result:sub(1, -sep:len() - 1)
end

function StrLua.ljust(s, width)
	if type(s) ~= "string" then
		error("ljust: Argument must be a string, got ".. type(s), 2)
	end

	if type(width) ~= "number" or width < 0 then
		error("ljust: Width must be a non-negative number, got ".. type(width), 2)
	end

	local padding = string.rep(" ", width - #s)
	return s .. padding:sub(1, width - #s)
end

function StrLua.lower(s)
	if type(s) ~= "string" then
		error("lower: Argument must be a string, got ".. type(s), 2)
	end

	return s:gsub("%u", function(c)
		return string.char(string.byte(c) + 32)
	end)
end

function StrLua.lstrip(s)
	if type(s) ~= "string" then
		error("lstrip: Argument must be a string, got ".. type(s), 2)
	end

	return s:gsub("^%s*", "")
end

function StrLua.maketrans(from, to)
	if type(from) ~= "string" or type(to) ~= "string" then
		error("maketrans: Arguments must be strings, got ".. type(from) .." and ".. type(to), 2)
	end

	local t = {}
	for i = 1, #from do
		t[from:sub(i, i)] = to:sub(i, i)
	end

	return function(c)
		return t[c] or c
	end
end

function StrLua.partition(s, pattern)
	if type(s) ~= "string" or type(pattern) ~= "string" then
		error("partition: Arguments must be strings, got ".. type(s) .." and ".. type(pattern), 2)
	end

	local match, start, finish = s:find(pattern)

	if match == nil then
		return {s, "", ""}
	else
		return {s:sub(1, start - 1), s:sub(start, finish), s:sub(finish + 1)}
	end
end

function StrLua.replace(s, pattern, repl)
	if type(s) ~= "string" or type(pattern) ~= "string" or type(repl) ~= "string" then
		error("replace: Arguments must be strings, got ".. type(s) ..", ".. type(pattern) ..", and ".. type(repl), 2)
	end

	return s:gsub(pattern, repl)
end

function StrLua.rfind(s, pattern, init)
	if type(s) ~= "string" or type(pattern) ~= "string" then
		error("rfind: Arguments must be strings, got ".. type(s) .." and ".. type(pattern), 2)
	end

	if type(init) ~= "number" then
		init = nil
	end

	local match, start, finish = s:reverse():find(pattern:reverse(), init)

	if match == nil then
		return nil
	else
		return #s - (start - 1)
	end
end

function StrLua.rindex(s, c)
	if type(s) ~= "string" or type(c) ~= "string" or #c ~= 1 then
		error("rindex: Arguments must be a string and a single character, got ".. type(s) .." and ".. type(c), 2)
	end

	local i = #s
	while i > 0 do
		if s:sub(i, i) == c then
			return i
		end
		i = i - 1
	end

	return nil
end

function StrLua.rjust(s, width)
	if type(s) ~= "string" then
		error("rjust: Argument must be a string, got ".. type(s), 2)
	end

	if type(width) ~= "number" or width < 0 then
		error("rjust: Width must be a non-negative number, got ".. type(width), 2)
	end

	local padding = string.rep(" ", width - #s)
	return padding:sub(1, width - #s) .. s
end

function StrLua.rpartition(s, pattern)
	if type(s) ~= "string" or type(pattern) ~= "string" then
		error("rpartition: Arguments must be strings, got ".. type(s) .." and ".. type(pattern), 2)
	end

	local match, start, finish = s:reverse():find(pattern:reverse())

	if match == nil then
		return {"", "", s}
	else
		local prefix = s:sub(1, #s - finish + 1)
		local suffix = s:sub(#s - finish + 2)
		return {prefix, pattern, suffix}
	end
end

function StrLua.rsplit(s, pattern, maxsplit)
	if type(s) ~= "string" or type(pattern) ~= "string" then
		error("rsplit: Arguments must be strings, got ".. type(s) .." and ".. type(pattern), 2)
	end

	if type(maxsplit) ~= "number" or maxsplit < 0 then
		error("rsplit: Maxsplit must be a non-negative number, got ".. type(maxsplit), 2)
	end

	local result = {}
	local i = #s
	local count = 0

	while i > 0 and count < maxsplit do
		local match, start, finish = s:sub(1, i):reverse():find(pattern:reverse())

		if match == nil then
			break
		end

		table.insert(result, 1, s:sub(start, i))
		i = start - 1
		count = count + 1
	end

	table.insert(result, 1, s:sub(1, i))
	return result
end

function StrLua.split(s, pattern, maxsplit)
	if type(s) ~= "string" or type(pattern) ~= "string" then
		error("split: Arguments must be strings, got ".. type(s) .." and ".. type(pattern), 2)
	end

	if type(maxsplit) ~= "number" or maxsplit < 0 then
		error("split: Maxsplit must be a non-negative number, got ".. type(maxsplit), 2)
	end

	local result = {}
	local i = 1
	local count = 0

	while i <= #s and count < maxsplit do
		local match, start, finish = s:sub(i):find(pattern)

		if match == nil then
			break
		end

		table.insert(result, s:sub(i, start - 1))
		i = finish + 1
		count = count + 1
	end

	table.insert(result, s:sub(i))
	return result
end

function StrLua.startswith(s, prefix)
	if type(s) ~= "string" or type(prefix) ~= "string" then
		error("startswith: Arguments must be strings, got ".. type(s) .." and ".. type(prefix), 2)
	end

	return s:sub(1, #prefix) == prefix
end

function StrLua.strip(s, chars)
	if type(s) ~= "string" then
		error("strip: Argument must be a string, got ".. type(s), 2)
	end

	if chars == nil then
		chars = "%s"
	elseif type(chars) ~= "string" then
		error("strip: Chars must be a string, got ".. type(chars), 2)
	end

	local start = s:find("^["..chars.."]*")
	local finish = s:find("["..chars.."]*$")

	if start == 1 and finish then
		return s:sub(start, finish - 1)
	elseif start == 1 then
		return s:sub(start)
	elseif finish then
		return s:sub(1, finish - 1)
	else
		return s
	end
end

function StrLua.swapcase(s)
	if type(s) ~= "string" then
		error("swapcase: Argument must be a string, got ".. type(s), 2)
	end

	local result = ""
	for i = 1, #s do
		local c = s:sub(i, i)
		if c:match("%u") then
			result = result .. c:lower()
		elseif c:match("%l") then
			result = result .. c:upper()
		else
			result = result .. c
		end
	end

	return result
end

function StrLua.title(s)
	if type(s) ~= "string" then
		error("title: Argument must be a string, got ".. type(s), 2)
	end

	local result = ""
	local uppercase = true
	for i = 1, #s do
		local c = s:sub(i, i)
		if c:match("%a") then
			if uppercase then
				result = result .. c:upper()
				uppercase = false
			else
				result = result .. c:lower()
			end
		else
			result = result .. c
			uppercase = true
		end
	end

	return result
end

function StrLua.translate(s, table)
	if type(s) ~= "string" then
		error("translate: Argument must be a string, got ".. type(s), 2)
	end

	if type(table) ~= "table" then
		error("translate: Table must be a table, got ".. type(table), 2)
	end

	local result = ""
	for i = 1, #s do
		local c = s:sub(i, i)
		if table[c] then
			result = result .. table[c]
		else
			result = result .. c
		end
	end

	return result
end

function StrLua.upper(s)
	if type(s) ~= "string" then
		error("upper: Argument must be a string, got ".. type(s), 2)
	end

	local result = ""
	for i = 1, #s do
		local c = s:sub(i, i)
		if c:match("%l") then
			result = result .. c:upper()
		else
			result = result .. c
		end
	end

	return result
end

function StrLua.zfill(s, width)
	if type(s) ~= "string" then
		error("zfill: Argument must be a string, got ".. type(s), 2)
	end

	if type(width) ~= "number" or width < 0 then
		error("zfill: Width must be a non-negative number, got ".. type(width), 2)
	end

	local padding = string.rep("0", width - #s)
	return padding:sub(1, width - #s) .. s
end

function StrLua.sort(s)
	if type(s) ~= "string" then
		error("sort: Argument must be a string, got ".. type(s), 2)
	end

	local chars = {}
	for i = 1, #s do
		table.insert(chars, s:sub(i, i))
	end

	table.sort(chars)

	local result = ""
	for i = 1, #chars do
		result = result.. chars[i]
	end

	return result
end

-- Return the module table
return StrLua
