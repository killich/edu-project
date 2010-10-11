require 'php_serialize'
require 'iconv'
$KCODE='u'
test_var= 'a:5:{s:4:"from";s:17:"Родители 7 взвода";s:2:"to";s:19:"Администратор сайта";s:5:"topic";s:11:"Поздравляем";s:3:"ask";s:154:"Поздравляем Кадетский корпус с 10-летием! Огромная благодарность всему коллективу школы и корпуса, кадетам  за подаренный праздник! МОЛОДЦЫ! Так держать! ";s:3:"ans";s:65:"Большое спасибо за оценку нашего труда! Будем стараться и дальше.";}'
test_var= Iconv.new("cp1251//IGNORE", "UTF-8").iconv(test_var)
target= File.new("parsed.txt", "w")
PHP.unserialize(test_var).each do |n, v|
  target.puts(n)
  target.puts(v)
end