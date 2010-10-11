=begin
  table_name= 'users'

  ActiveRecord::Base.connection.select_values('show tables').each do |table_name|
    next if ['schema_migrations'].include? table_name
    ActiveRecord::Base.connection.execute("DELETE FROM #{table_name}")
  end
=end

###################################################################################################
# Пользователи
###################################################################################################

Factory.define :user do |u| end
Factory.define :empty_user, :class => User do |u|
  u.crypted_password '1111111111'
  u.salt 'salt'
end
  
# Создал фабрику для Пользователя (User) admin
Factory.define :admin, :class => User do |u|
  u.login 'admin'
  u.email 'admin@iv-schools.ru'
  u.crypted_password 'admin-admin'
  u.salt 'salt'
  u.name 'Зыкин Илья Николаевич'
end

# Создал фабрику для Пользователя (User) Иванов
Factory.define :ivanov, :class => User do |u|
  u.login 'ivanov'
  u.email 'ivanov@iv-schools.ru'
  u.crypted_password 'ivanov'
  u.salt 'salt'
  u.name 'Иванов Петр Сергеевич'
end

# Создал фабрику для Пользователя (User) petrov
Factory.define :petrov, :class => User do |u|
  u.login 'petrov'
  u.email 'petrov@iv-schools.ru'
  u.crypted_password 'petrov'
  u.salt 'salt'
  u.name 'Петров Иван Андреевич'
end
###################################################################################################
# Пользователи
###################################################################################################

Factory.define :profile do |pf| end   # Создал фабрику для Профиля пользователя (Profile)

###################################################################################################
# Политики доступа
###################################################################################################


Factory.define :group_resource_policy do |grp| end        # Создал фабрику для групповой политики для объекта (GroupResourcePolicy)

###################################################################################################
# Групповая политика к ресурсу
###################################################################################################


=begin
#-------------------------------------------------------------------------------------------------------
# Правовые группы
#-------------------------------------------------------------------------------------------------------
  # Правовой набор администратора портала (Групповой набор)
  policy_set={
    'pages'=>{
      'manager'=>true
    }
  }#policy_set

  Factory.create(:role,
    :name => 'administrator',
    :title => 'Администратор портала',
    :description=>'Правовой набор администратора портала',
    :settings=> policy_set.to_yaml
  )

  Factory.create(:role,
    :name => 'site_administrator',
    :title => 'Администратор сайта',
    :description=>'Правовой набор администратора сайта',
    :settings=> policy_set.to_yaml
  )
#-------------------------------------------------------------------------------------------------------
# ~Правовые группы
#-------------------------------------------------------------------------------------------------------            

#-------------------------------------------------------------------------------------------------------
# Настройки для профайла пользователя
#-------------------------------------------------------------------------------------------------------
  profile_set={
    'access'=>{
      'info'=>true,
      'contacts'=>true,
      'birthday'=>true
    }
  }#profile_set
#-------------------------------------------------------------------------------------------------------
# ~Настройки для профайла пользователя
#-------------------------------------------------------------------------------------------------------

#-------------------------------------------------------------------------------------------------------
# Администратор портала
#-------------------------------------------------------------------------------------------------------
# Учетная запись администратора
admin_user= Factory.create(:user,
  :login => 'adminnistrator',
  :email => 'adminnistrator@admin.ru',
  :crypted_password=>'admin',
  :salt=>'salt',
  :name=>'Зыкин Илья Николаевич',
  :role_id=>Role.find_by_name('administrator').id
)


# Профайл пользователя
admins_profile= Factory.create(:profile,
  :user_id => admin_user.id,
  :birthday => (DateTime.now-24.years),
  :native_town=>'Магаданская область',
  
  :home_phone => '',
  :cell_phone =>'',
  :icq => 'не помню',
  :jabber => 'нет',
  :public_email => 'killich@mail.ru',
  :web_site => 'iv-schools.ru',

  :activity => 'Интернет разработка, Преподавание информатики',
  :interests => 'Информационные технологии и безопасность, танцы, музыка, стихи',
  :music => 'Хорошая и разная. От классики до качественной электронной музыки',
  :movies => 'Достучаться до небес',
  :tv => 'Прожектор пересхилтон',
  :books =>'Мастер и Маргарита',
  :citation => 'Я часть той силы, что вечно хочет зла, но сотворяет благо...',
  :about_myself => 'надеюсь, что для большинства я просто хороший человек',

  :study_town  => '',
  :study_place => '',
  :study_status => 'Аспирант',

  :work_town  => '',
  :work_place => '№36',
  :work_status => 'Преподаватель информатики',

  :setting => profile_set.to_yaml 
)


# Связать пользователя и его профайл
admin_user.update_attribute(:profile_id, admins_profile.id)

#-------------------------------------------------------------------------------------------------------
# ~Администратор портала
#-------------------------------------------------------------------------------------------------------

logins= %w{ iv36 iv43 kohma5 kohma6 kohma7 kohma5vecher }
logins.each do |login|
  #-------------------------------------------------------------------------------------------------------
  # Администратор сайта X
  #-------------------------------------------------------------------------------------------------------
  # Учетная запись администратора сайта
  user= Factory.create(:user,
    :login => "#{login}",
    :email => "#{login}@iv-schools.ru",
    :crypted_password=>"#{login}",
    :salt=>'salt',
    :name=>"Администратор сайта #{login}.iv-schools.ru",
    :role_id=>Role.find_by_name('site_administrator').id
  )
       
  # Профайл пользователя
  profile= Factory.create(:profile,
    :user_id => user.id,
    :birthday => (DateTime.now-30.years),
    :work_town  => 'Иваново',
    :work_place => "Школа #{login}",
    :work_status => 'Преподаватель информатики',

    :setting => profile_set.to_yaml 
  )
  
  # Связать пользователя и его профайл
  user.update_attribute(:profile_id, profile.id)
end#logins.each

=end