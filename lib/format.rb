module Format
  # adds by I.Zykin
	EMAIL = /^[_a-z0-9\+\.\-]+\@[_a-z0-9\-]+\.[_a-z0-9\.\-]+$/i    	
	PASSWORD = /^[\_a-zA-Z0-9\.\-]+$/
  
  # Запретить в Логине точки и знаки нижнего подчеркивания
  # Вначале и в конце логина - только буквы
  # Любое кол-во тире - как одно
  LOGIN= /^[a-zA-Z][a-zA-Z0-9_\-]*[a-zA-Z0-9]$/
  
  LATIN_AND_SAFETY_SYMBOLS= /^[a-zA-Z][a-zA-Z0-9_\-]*[a-zA-Z0-9]$/
  #/^[\_a-zA-Z0-9\.\-]+$/
  #  /[a-zA-z][a-zA-z0-9\-]*/ # /[a-zA-z][a-zA-z0-9-]*/ # /[a-zA-z][a-zA-z0-9-]/ # /[a-zA-z][a-zA-z0-9\-]*[a-zA-z0-9]/ #/[a-zA-Z][a-zA-Z0-9_\-]*[a-zA-Z0-9]/
	
	# matches everything to the last \ or / in a string. 
	# can chop of path of a filename like this : '/tobi/home/tobi.jpg'.sub(/^.*[\\\/]/,'') => tobi.jpg
	FILENAME = /^.*[\\\/]/ 
	
	JAST_LATIN_CHARS = /^[\_a-zA-Z0-9]+$/ # Только латинские символы, нижнее подчеркивание и цифры
	JAST_CHARS_AND_SLASHES = /^[\_a-zA-Z0-9\/]+$/ # Только латинские символы, нижнее подчеркивание, цифры и слешы

	# good for replacing all special chars with something else, like an underscore
	FILENORMAL = /[^a-zA-Z0-9.]/

	# Laxly matches an IP Address , would also pass numbers > 255 though
	IP_ADDRESS = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/

	# Laxly matches an HTTP(S) URI
	HTTP_URI = /^https?:\/\/\S+$/
	# Мягкая проверка на адрес сайта
	SOFT_URI = /^(https?:\/\/)|(www.)\S+$/
  # Проверка на соответствие целому числу
  NUMBERS = /^[0-9]+$/
end