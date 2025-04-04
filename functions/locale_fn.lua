local supported_locales = {"enUS", "frFR", "esES", "deDE"}

function is_locale_supported(locale)
   for _, supported_locale in pairs(supported_locales) do
      if (supported_locale == locale) then
            return true
      end
   end

   return false
end

function get_locale_id(locale)
    for key, value in pairs(supported_locales) do
        if (value == locale) then
            return key
        end
    end

    return 1 -- enUS par defaut
end

function get_locale_by_id(id)
    return supported_locales[id]
end