 # Создал фабрику для Ролей доступа (Role)
Factory.define :role do |r| end

###################################################################################################
# Роли (Набор Груповых политик без ограничения по времени и кол-ву доступа)
###################################################################################################

Factory.define :page_manager_role, :class => Role do |r|
  policy= {
    :pages=>{
      :tree=>true,
      :manager=>true
    },
    :blocked=>{
      :yes=>false,
      :no=>true
    }
  }
  r.name   'self_page_manager'
  r.title 'Редактор своих страниц'
  r.description 'Правовой набор пользователя, который может редактировать свои страницы'
  r.settings(policy.to_yaml)
end

# РОЛЬ АДМИНИСТРАТОРА ПОРТАЛА

Factory.define :administrator_role, :class => Role do |r|
  policy= {
    :administrator=>{
      :pages=>true,
      :documents=>true,
      :blogs=>true,
      :albums=>true,
      :forums=>true
    }
  }
  r.name   'administrator'
  r.title 'Администратор портала'
  r.description 'Правовой набор Администратора портала'
  r.settings(policy.to_yaml)
end

# РОЛЬ ЗАРЕГИСТРИРОВАННОГО ПОЛЬЗОВАТЕЛЯ
Factory.define :registrated_user_role, :class => Role do |r|
  policy= {
    :pages=>{
      :index=>true,
      :show=>true
    },
    :documents=>{
      :index=>true,
      :show=>true
    },
    :blogs=>{
      :index=>true,
      :show=>true
    },
    :albums=>{
      :index=>true,
      :show=>true
    },
    :forums=>{
      :index=>true,
      :show=>true
    }
  }
  r.name   'registrated_user'
  r.title 'Зарегистрированный пользователь'
  r.description 'Правовой набор зарегистрированного пользователя'
  r.settings(policy.to_yaml)
end

# РОЛЬ ЗАВЕРЕННОГО ПОЛЬЗОВАТЕЛЯ
Factory.define :guaranted_user_role, :class => Role do |r|
  policy= {
    :pages=>{
      :index=>true,
      :show=>true
    },
    :documents=>{
      :index=>true,
      :show=>true
    },
    :blogs=>{
      :index=>true,
      :show=>true,
      :new=>true,
      :create=>true,
      :edit=>true,
      :update=>true,
      :destroy=>true
    },
    :albums=>{
      :index=>true,
      :show=>true,
      :new=>true,
      :create=>true,
      :edit=>true,
      :update=>true,
      :destroy=>true
    },
    :forums=>{
      :index=>true,
      :show=>true
    }
  }
  r.name   'guaranted_user'
  r.title 'Заверенный пользователь'
  r.description 'Правовой набор заверенного пользователя'
  r.settings(policy.to_yaml)
end

# РОЛЬ АДМИНИСТРАТОРА ШКОЛЬНОГО САЙТА
Factory.define :site_administrator_role, :class => Role do |r|
  policy= {
    :pages=>{
      :index=>true,
      :show=>true,
      :manager=>true,
      :new=>true,
      :create=>true,
      :edit=>true,
      :update=>true,
      :destroy=>true,
      :up=>true,
      :down=>true,
    },
    :documents=>{
      :index=>true,
      :show=>true,
      :new=>true,
      :create=>true,
      :edit=>true,
      :update=>true,
      :destroy=>true
    },
    :blogs=>{
      :index=>true,
      :show=>true,
      :new=>true,
      :create=>true,
      :edit=>true,
      :update=>true,
      :destroy=>true
    },
    :albums=>{
      :index=>true,
      :show=>true,
      :new=>true,
      :create=>true,
      :edit=>true,
      :update=>true,
      :destroy=>true
    },
    :forums=>{
      :index=>true,
      :show=>true,
      :new=>true,
      :create=>true,
      :edit=>true,
      :update=>true,
      :destroy=>true
    }
  }
  r.name   'site_administrator'
  r.title 'Администратор школьного сайта'
  r.description 'Правовой набор администратора школьного сайта'
  r.settings(policy.to_yaml)
end