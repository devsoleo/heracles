function array_search(array, value)
	local index = {}

	for k, v in pairs(array) do
		index[v] = k
	end

 	return index[value]
end

function array_size(array)
	if array ~= nil then
		local counter = 0

		for index in pairs(array) do
		    counter = counter + 1
		end

		return counter
	else
		return nil
	end
end

function array_merge(t1, t2)
    for i=1, #t2 do
        t1[#t1 + 1] = t2[i]
    end

    return t1
end

function array_shuffle(t)
    local rand = math.random 
    assert(t, "table.shuffle() expected a table, got nil")
    local iterations = #t
    local j

    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

-------------------------------------------------------------------------------------------------

-- Cette fonction renvoie la taille des variables des types suivant : string, table
function sizeof(variable)
	if type(variable) == "string" then
		return #variable
	elseif type(variable) == "table" then
		return array_size(variable)
	else
		return nil
	end
end

function clear_table(table)
	if table == nil then
		return nil
	end

	for k in pairs(table) do
		table[k] = nil
	end

	return table
end