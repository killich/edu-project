# Фабрика пустого профайла
Factory.define :empty_profile, :class => Profile do |pf|  
  pf.birthday(DateTime.now-30.years)
  pf.native_town 'город'
  pf.home_phone  '---'
  pf.cell_phone  '---'
  pf.icq   'нет'
  pf.jabber   'нет'
  pf.public_email 'test@email.ru'
  pf.web_site   'iv-schools.ru'

  pf.activity   '---'
  pf.interests   '---'
  pf.music   '---'
  pf.movies   '---'
  pf.tv   '---'
  pf.books  '---'
  pf.citation   '---'
  pf.about_myself   '---'

  pf.study_town    '---'
  pf.study_place   '---'
  pf.study_status   '---'

  pf.work_town    '---'
  pf.work_place   '---'
  pf.work_status   '---'

  pf.setting(Hash.new.to_yaml)
end