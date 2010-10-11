#-------------------------------------------------------------------------------------------------------
# String
#-------------------------------------------------------------------------------------------------------
class String
  def endl2br
    self.gsub("\n", "<br />")
  end
  
  def space2br
    # Любое кол-во пробелов на один
    # удалить пробелы в начале и конце
    str= self.strip
    str.gsub!(/\s+/, " ")
    str.gsub(/\s+/, '<br />')
  end
  
  def sharps2anchor
    # "Hello World! ###world I'm String!".sharps2anchor => Hello World! <a href="#world" name="world" title="world"></a> I'm String!
    str = self.gsub(/###(\S*)/, " <a name=\"\\1\" href=\"#\\1\" title=\"\\1\"></a> ")
    return str
  end
end
#-------------------------------------------------------------------------------------------------------
# ~String
#-------------------------------------------------------------------------------------------------------



#-------------------------------------------------------------------------------------------------------
# Hash
#-------------------------------------------------------------------------------------------------------
# Рекурсивное объединение Хеш массивов
# Ключи хешей всегда сохранять как символы!

class Hash
  # Рекурсивно объединить 
  def recursive_merge!(hash= nil)
    return self unless hash.is_a?(Hash)
    base= self
    hash.each do |key, v|
      if base[key.to_sym].is_a?(Hash) && hash[key.to_sym].is_a?(Hash)
        base[key.to_sym]= base[key.to_sym].recursive_merge!(hash[key.to_sym])
      else
        base[key.to_sym]= hash[key.to_sym]
      end
    end
    base.to_hash
  end#recursive_merge!
  
  # Рекурсивно привести все значения к исходному состоянию
  def recursive_set_values_on_default!(default_value= false)
    base= self
    base.each do |key, v|
      if base[key.to_sym].is_a?(Hash)
        base[key.to_sym]= base[key.to_sym].recursive_set_values_on_default!(default_value)
      else
        base[key.to_sym]= default_value
      end
    end
  end#recursive_set_values_on_default
  
  # Рекурсивно объединить и установить в качестве значения указанный параметр default_value
  def recursive_merge_with_default!(hash= nil, default_value= true)
    return self unless hash.is_a?(Hash)
    base= self
    hash.each do |key, v|
      if base[key.to_sym].is_a?(Hash) && hash[key.to_sym].is_a?(Hash)
        base[key.to_sym]= base[key.to_sym].recursive_merge_with_default!(hash[key.to_sym], default_value)
      else
        base[key.to_sym]= default_value
      end
    end
    base.to_hash
  end#recursive_merge_with_default
end#Hash
#-------------------------------------------------------------------------------------------------------
# ~Hash
#-------------------------------------------------------------------------------------------------------