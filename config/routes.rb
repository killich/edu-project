ActionController::Routing::Routes.draw do |map|
  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  
  #map.resources :admins, :collection=>{:index=>:get}

  map.resources :users,
    :collection=>{:cabinet=>:get, :profile=>:get},
    :member=>{ :base_header=>:put }

  map.resources :profiles,
    :member=>{ :name=>:put, :avatar=>:put }

  map.resources :pages,
    :collection=>{:map=>:get, :manager=>:get, :textiletest=>:post, :htmltest=>:post},
    :member=>{ :up=>:get, :down=>:get }
    
  map.resources :updates

  map.resources :storage_sections
  map.resources :storage_files
  
  map.resources :news, :controller => 'reports',
    :member=>{ :up=>:get, :down=>:get }
              
  map.resources :questions,
    :collection=>{ :box=>:get },
    :member=>{ :physic_delete=>:delete }
    
  map.resources :reports
  map.resource :session
  

  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  
  map.root :controller=>'pages', :action=>'first'
  
  # Для департамента образования
  # edustat.php
  map.connect '/edustat', :controller => 'pages', :action => 'edustat'
  map.connect '/edustat.:format', :controller => 'pages', :action => 'edustat'
  
  # Администраторский роутер - работает с app/controllers/admins, app/view/admins
  # /admins/users/new, /admins/users/:id/edit
  # /admins/users/:id/change_role    
  # /admins/pages/new
  # /admins/pages/:id/edit     
  # /admins/roles/new
  # /admins/roles/:id/edit
  # /admins/roles/:id/new_role_section
  # /admins/roles/:id/new_role_rule
  # /admins/roles/:role_id/sections/new
  # /admins/roles/:role_id/sections/:id/edit
  # /admins/roles/:role_id/sections/:id/new_rule
  # /admins/roles/:role_id/sections/:id/delete_rule/?name=some_name
  map.namespace(:admins) do |admin|
    admin.resources :users,
      :member=>{:change_role => :post},
      :collection=>{:new => :get}

    admin.resources :pages
    
    admin.resources :roles,
      :member=>{ :new_role_section=>:post, :new_role_rule=>:post } do |role|
        role.resources :sections,
          :controller=>'role_section',
          :member=>{ :new_rule=>:get, :delete_rule=>:delete }
      end
  end# map.namespace(:admins)

  # Стандартная маршрутизация
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end