module AnsHelper
  #-------------------------------------------------------------------------------------------------------
  # Awesome Nested Set View Helper
  # Ilya Zykin / zykin-ilya@ya.ru / Russia, Ivanovo 2009
  # Илья Зыкин - тот самый учитель информатики
  #-------------------------------------------------------------------------------------------------------

  #   :ruby
  #     localize={
  #       :id_of_element=>'Идентификатор страницы: ',
  #       
  #       :cant_be_moved=>'Элемент не может быть перемещен.',
  #       :move_up=>'Переместить элемент вверх: ',
  #       :move_down=>'Переместить элемент вниз: ',
  #       :edit=>'Редактировать элемент: ',
  #       :delete=>'Удалить элемент: ',
  #       :create_child=>'Создать дочерний элемент для: ',
  #       :delete_confirm=>'Вы уверенны, что хотите удалить элемент?',
  #       :sub_sections_must_be_deleted=>'Невозможно удалить элемент, пока существуют дочерние элементы.'
  #     }
  #   =ans_show_tree(@pages,    :clean=>false, :idname=>'id', :localize=>localize, :class_name=>'Report')
  #   =ans_manager_tree(@pages, :clean=>false, :idname=>:zip, :localize=>localize, :childs_add=>false)

    #-------------------------------------------------------------------------------------------------------
    # Отрисовка элементов управления в административном дереве
    #-------------------------------------------------------------------------------------------------------
    def ans_controls(elem, options= {})
      opts= {
        :class_name=>nil, # Элементы какого класса к нам поступают?
        :idname=>'id',    # Какое поле у данного ресурса следует брать как идентификатор
        :title=>'title',  # Какое поле является заголовочным?
        :localize=> {},   # Массив локализованного текста

        :first=>false,    # Флаг первого элемента
        :last=>false,     # Флаг последнего элемента
        :childs=>false,   # Флаг того, что есть дочерние элементы
        :childs_add=>true # Флаг того, что нужно отобразить функционал добавления дочернего элемента
      }.merge!(options)
      #--------------------------------------------------
      opts[:localize][:cant_be_moved]=                (opts[:localize][:cant_be_moved])                 ? (opts[:localize][:cant_be_moved])                 : "can't be moved."
      opts[:localize][:move_up]=                      (opts[:localize][:move_up])                       ? (opts[:localize][:move_up])                       : 'move up: '
      opts[:localize][:move_down]=                    (opts[:localize][:move_down])                     ? (opts[:localize][:move_down])                     : 'move down: '
      opts[:localize][:edit]=                         (opts[:localize][:edit])                          ? (opts[:localize][:edit])                          : 'edit: '
      opts[:localize][:create_child]=                 (opts[:localize][:create_child])                  ? (opts[:localize][:create_child])                  : 'create child: '
      opts[:localize][:delete]=                       (opts[:localize][:delete])                        ? (opts[:localize][:delete])                        : 'delete: '
      opts[:localize][:delete_confirm]=               (opts[:localize][:delete_confirm])                ? (opts[:localize][:delete_confirm])                : 'delete confirm.'
      opts[:localize][:sub_sections_must_be_deleted]= (opts[:localize][:sub_sections_must_be_deleted])  ? (opts[:localize][:sub_sections_must_be_deleted])  : 'sub-sections must be deleted.'
      #--------------------------------------------------
      # Если не указан класс элементов - то определим его по первому элементу дерева (для формирования ссылок)
      opts[:class_name]= opts[:class_name] ? opts[:class_name].to_s.downcase : elem.class.to_s.downcase
      #--------------------------------------------------
      # Если первый элемент - то, ссылку вверх не генерируем
      if opts[:first]
        up = link_to '', '#',:title=>opts[:localize][:cant_be_moved], :class=>'button cantup'
      else
        # Формируем путь ссылки
        # up_#{news}_path(elem.send(opts[:idname]).to_s) ==> up_news_path(elem.zip) ==> up_news_path('N1234')
        link_path= eval("up_#{opts[:class_name]}_path(elem.send(opts[:idname]).to_s)")
        up = link_to '', link_path, :title=>opts[:localize][:move_up]+"#{elem.title}", :class=>'button up'
      end
      #--------------------------------------------------
      # Если последний элемент - то, ссылку вниз не генерируем
      if opts[:last]
        down=   link_to '', '#', :title=>opts[:localize][:cant_be_moved], :class=>'button cantdown'
      else
        link_path= eval("down_#{opts[:class_name]}_path(elem.send(opts[:idname]).to_s)")
        down=   link_to '', link_path, :title=>opts[:localize][:move_down] + "#{elem.title}", :class=>'button down'
      end
      #--------------------------------------------------
      link_path= eval("edit_#{opts[:class_name]}_path(elem.send(opts[:idname]).to_s)")
      edit=   link_to '', link_path, :title=>opts[:localize][:edit] + "#{elem.title}", :class=>'button edit'
      new= ''
      if opts[:childs_add]
        link_path= eval("new_#{opts[:class_name]}_path(:parent_id=>elem.send(opts[:idname]).to_s)")
        new= link_to '', link_path, :title=>opts[:localize][:create_child] + "#{elem.title}", :class=>'button new'
      end
      #--------------------------------------------------
      # Если дочерние элементы отсутствуют
      if opts[:childs]
        link_path= eval("#{opts[:class_name]}_path(elem.send(opts[:idname]).to_s)")
        delete=  link_to('', link_path, :method=>:delete, :title=>opts[:localize][:delete] + "#{elem.title}", :confirm=>opts[:localize][:delete_confirm], :class=>'button delete') 
      else
        delete=  link_to('', '#',  :title=>opts[:localize][:sub_sections_must_be_deleted], :class=>'button undeleted', :onclick=>"javascript:alert('#{opts[:localize][:sub_sections_must_be_deleted]}');return false;")
      end
      #--------------------------------------------------
      # Результирующий HTML      
      up+down+edit+new+delete
    end

    # Берем дерево и узел в нем
    # Рисуем узел, и удаляем его из дерева
    # Рисуем рекурсивно все элементы дерева, у которых такой же parent_id удаленного узела, и удаляем их из дерева.
    # Тем самым при каждой рекурсии облегчаем дерево
    # Отрисовываем элементы
    # Отрисовка карты сайта
    #--------------------------------------------------
    # Дерево элементов для администратора
    # ans_manager_tree(@pages_tree)
    # ans_manager_tree(@pages_tree, :clean=>false, :idname=>:id, :class_name=>'Report')
    #  :ruby
    #    localize={
    #      :id_of_element=>'Идентификатор страницы: ',
    #      
    #      :cant_be_moved=>'Элемент не может быть перемещен.',
    #      :move_up=>'Переместить элемент вверх: ',
    #      :move_down=>'Переместить элемент вниз: ',
    #      :edit=>'Редактировать элемент: ',
    #      :delete=>'Удалить элемент: ',
    #      :create_child=>'Создать дочерний элемент для: ',
    #      :delete_confirm=>'Вы уверенны, что хотите удалить элемент?',
    #      :sub_sections_must_be_deleted=>'Невозможно удалить элемент, пока существуют дочерние элементы.'
    #    }
    #  =ans_manager_tree(@pages_tree, :clean=>false, :idname=>:zip, :localize=>localize, :title=>:description, :class_name=>'Page', :childs_add=>false)
    #--------------------------------------------------
    def ans_manager_tree(tree, options= {})
      #--------------------------------------------------
      result= ''
      #--------------------------------------------------
      opts= {
        # system params # do not touch it, please >:0)
        :node=>nil,       # Узел
        :root=>false,     # Флаг корневого элемента
        :first=> false,   # Флаг первого элемента
        :last=> false,    # Флаг последнего элемента
        
        # user params
        :clean=>true,     # Следует ли после отрисовки удалять элмент из дерева (для облегчения следующего обхода дерева)
        :idname=>'id',    # Какое поле у данного ресурса следует брать как идентификатор
        :title=>'title',  # Какое поле является заголовочным?
        :class_name=>nil, # Элементы какого класса к нам поступают?
        :childs_add=>true,# Можно ли создавать дочерние элементы (влияет на отображение элементов управления)
        :localize=> {}    # Массив локализованного текста
      }.merge!(options)
      #--------------------------------------------------
      node= opts[:node]
      root= opts[:root]
      
      opts[:localize][:id_of_element]= (opts[:localize][:id_of_element]) ? (opts[:localize][:id_of_element]) : 'Id of element: '
      #--------------------------------------------------
      # Если дерево пустое - то и нечего его рисовать
      return '' if tree.empty?
      # Если не указан класс элементов - то определим его по первому элементу дерева (для формирования ссылок)
      opts[:class_name]= opts[:class_name] ? opts[:class_name].to_s.downcase : tree.first.class.to_s.downcase
      #--------------------------------------------------
      #Предположим - пришел корень
      unless node
        # Выбераем из дерева корневые элементы
        roots= tree.select{|elem| elem.parent_id.nil?}
        # Узнаем id первого и последнего элементов массива
        roots_first_id= roots.empty? ? nil : roots.first.id
        roots_last_id=  roots.empty? ? nil : roots.last.id
        # Отрисовать каждый элемент
        # И его дочерние элементы
        roots.each do |root|
          # Если id элемента который мы рисуем совпал с id первого или последнего элементов
          # То соответствено устанавливаем флаг :first или :last
          # Требуется для отрисовки стрелок вверх/вниз, или их блокировки
          is_first= (root.id==roots_first_id)
          is_last= (root.id==roots_last_id)
          # Опции совместить с нужными доп.параметрами
          opts.merge!({:node=>root, :root=>true, :first=>is_first, :last=>is_last})
          # Отрисовать фрагмент дерева
          result<< ans_manager_tree(tree, opts)
        end#roots.each
      else
        res= ''
        child_res= ''
        # Имеем узел
        # узнать кол-во дочерних элементов данного узла
        # Это нужно для того, что бы узнать - стоит ли рисовать кнопку удаления
        # (узел, у которого есть дочерние страницы - не удаляем!)
        childs= tree.select{|elem| elem.parent_id == node.id}
        # Блок с элементами управления
        # Здесь уже должно быть известно - первый элемент или последний
        opts.merge!({:childs=>childs.blank?})
        res<< content_tag(:div, ans_controls(node, opts), :class=>:controls) #|up, down, delete, edit, new|
        # Формируем путь ссылки
        # page_path(node.send(opts[:idname]).to_s) ==> page_path(node.id) ==> page_path('1234')
        link_path= eval("#{opts[:class_name]}_path(node.send(opts[:idname]).to_s)")
        # Блок с названием страницы (ссылка)
        
        link_txt=  node.send(opts[:title])
        link_txt= Sanitize.clean(link_txt , SatitizeRules::Config::TITLE)
        link_txt = 'Имя не определено' if link_txt.blank?
        
        res<< content_tag(:div, link_to(link_txt, link_path, :title=>opts[:localize][:id_of_element] + node.send(opts[:idname]).to_s), :class=>"link #{'root' if root}")
        # Обернуть в один блок
        res= content_tag(:div, res, :class=>:elem)
        # Получить id узла
        node_id= node.id
        # Удаляем узел из дерева, при следующей рекурсии придется обходить меньше элементов =)
        # Оптимизатор хренов =)
        tree.delete(node) if opts[:clean]
        # Узнаем id первого и последнего элементов массива дочерних элементов
        childs_first_id= childs.empty? ? nil : childs.first.id
        childs_last_id=  childs.empty? ? nil : childs.last.id
        # Делаем все тоже самое для дочерних. Отрисуем дочерний элемент, и все дочерние
        childs.each do |elem|
          # Если id элемента который мы рисуем совпал с id первого или последнего элементов
          # То соответствено устанавливаем флаг :first или :last
          # Требуется для отрисовки стралов вверх/вниз, или их блокировки
          is_first= (elem.id==childs_first_id)
          is_last= (elem.id==childs_last_id)
          # Опции совместить с нужными доп.параметрами
          opts.merge!({:node=>elem, :root=>false, :first=>is_first, :last=>is_last})
          # Отрисовать фрагмент дерева
          child_res << ans_manager_tree(tree, opts)
        end#childs.each
        # Если есть дочерние - обернем их
        child_res= child_res.blank? ? '' : content_tag(:div, child_res, :class=>:childs)
        result<<(res + child_res)
      end#unless node
      result
    end
    #-------------------------------------------------------------------------------------------------------
    # ans_manager_tree(@pages)
    #-------------------------------------------------------------------------------------------------------

    #-------------------------------------------------------------------------------------------------------
    # Список элментов
    # ans_show_tree(@pages, :idname=>'zip', :clean=>true)
    # ans_show_tree(@pages, :idname=>:zip, :title=>'zip', :clean=>false, :localize=>{:id_of_element=>'Id of element:'})
    # :ruby
    #   localize={
    #     :id_of_element=>t('page.zip_of_page') # i18
    #   }
    # ans_show_tree(@pages_tree, :clean=>false, :class_name=>'Page', :idname=>'zip', :localize=>localize)
    #-------------------------------------------------------------------------------------------------------
    def ans_show_tree(tree, options= {})
            #--------------------------------------------------
      result= ''
      #--------------------------------------------------
      opts= {
        :node=>nil,       # Узел
        :root=>false,     # Флаг корневого элемента
        :clean=>true,     # Следует ли после отрисовки удалять элмент из дерева (для облегчения следующего обхода дерева)
        :idname=>'id',    # Какое поле у данного ресурса следует брать как идентификатор
        :title=>'title',  # Какое поле является заголовочным?
        :class_name=>nil, # Элементы какого класса к нам поступают?
        :localize=> {}    # Массив локализованного текста
      }.merge!(options)
      #--------------------------------------------------
      # Если дерево пустое - то и нечего его рисовать
      return '' if tree.empty?
      # Если не указан класс элементов - то определим его по первому элементу дерева (для формирования ссылок)
      class_name= opts[:class_name] ? opts[:class_name].to_s.downcase : tree.first.class.to_s.downcase
      #--------------------------------------------------
      # Если не указан узел для отрисовки - это должен быть корень дерева (пришел корень)
      unless opts[:node]
        # Выбераем из дерева корневые элементы. У них нет родителя
        roots= tree.select{|elem| elem.parent_id.nil?}
        # Отрисовать каждый элемент и его дочерние элементы
        roots.each{|root| result<< ans_show_tree(tree, opts.merge!({:node=>root, :root=>true}))}
      else
        child_res= ''
        # Указан конкретный узел
        # Отрисовываем данный узел
        # Формируем путь ссылки
        # page_path(node.send(idname).to_s) ==> page_path(node.id) ==> page_path('1234')
        link_path= eval("#{class_name}_path(opts[:node].send(opts[:idname]).to_s)")
        link_txt=  opts[:node].send(opts[:title])
        link_txt= Sanitize.clean(link_txt , SatitizeRules::Config::TITLE)
        link_txt = 'Имя не определено' if link_txt.blank?
        
        title_txt = opts[:localize][:id_of_element].to_s + opts[:node].send(opts[:idname]).to_s
        res= content_tag(:div, link_to(link_txt, link_path, :title=>title_txt), :class=>(opts[:root] ? 'root' : 'child'))
        # Выбираем дочерние узлы к данному
        childs= tree.select{|elem| elem.parent_id == opts[:node].id}
        # Удаляем узел из дерева, при следующей рекурсии придется обходить меньше элементов =)
        tree.delete(opts[:node]) if opts[:clean]
        # Делаем все тоже самое для дочерних. Отрисуем дочерний элемент, и все дочерние
        childs.each {|elem| child_res << ans_show_tree(tree, opts.merge!({:node=>elem, :root=>false}))}
        # Если есть дочерние - обернем их
        child_res= child_res.blank? ? '' : content_tag(:div, child_res, :class=>:childs)
        # Формируем результат
        
        result<<(res + child_res)
      end #unless node
      #--------------------------------------------------
      result
    end
    #-------------------------------------------------------------------------------------------------------
    # ~ans_show_tree
    #-------------------------------------------------------------------------------------------------------
  
  #-------------------------------------------------------------------------------------------------------
  # ~Awesome Nested Set View Helper
  #-------------------------------------------------------------------------------------------------------
  
end