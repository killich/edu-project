module PagesHelper

  #-------------------------------------------------------------------------------------------------------
  # ~Nested Set View Helpers
  #-------------------------------------------------------------------------------------------------------

=begin
    tree_messages=>{
        :cant_be_moved=>'Элемент не может быть перемещен',
        :move_up=>'Переместить элемент вверх',
        :move_down=>'Переместить элемент вниз',
        :edit=>'Редактировать элемент',
        :create_child=>'Создать дочерний элемент',
        :delete=>'Удалить элемент',
        :delete_confirm=>'Вы уверенны, что хотите удалить элемент?',
        :sub_sections_must_be_deleted=>'Невозможно удалить элемент, пока существуют дочерние элементы'
    }
=end
    
    #-------------------------------------------------------------------------------------------------------
    # Страница - Карта редактора
    #-------------------------------------------------------------------------------------------------------
    # Берем дерево и узел в нем
    # Рисуем узел, и удаляем его из дерева
    # Рисуем рекурсивно все элементы дерева, у которых такой же parent_id удаленного узела, и удаляем их из дерева.
    # Тем самым при каждой рекурсии облегчаем дерево
    # Отрисовываем элементы
    # Отрисовка карты сайта
    def admin_controls(elem, options= {})  
      up=             options[:up]        ? options[:up]        : true
      down=           options[:down]      ? options[:down]      : true    
      edit=           options[:edit]      ? options[:edit]      : true
      first=          options[:first]     ? options[:first]     : false
      last=           options[:last]      ? options[:last]      : false
      has_no_childs=  options[:childs]    ? options[:childs]    : false
      
      # Если первый элемент - то, ссылку вверх не генерируем
      if first
        up = link_to '', '#',:title=>t('page.cant_be_move'), :class=>'button cantup'
      else
        up = link_to '', up_page_path(elem.zip), :title=>"#{t('page.move_up')} #{elem.title}", :class=>'button up'
      end
      
      # Если последний элемент - то, ссылку вниз не генерируем
      if last
        down=   link_to '', '#', :title=>t('page.cant_be_move'), :class=>'button cantdown'
      else
        down=   link_to '', down_page_path(elem.zip), :title=>"#{t('page.move_down')} #{elem.title}", :class=>'button down'
      end

      edit=   link_to '', edit_page_path(elem.zip),             :title=>"#{t('page.edit')} #{elem.title}", :class=>'button edit'
      new=    link_to '', new_page_path(:parent_id=>elem.zip),  :title=>"#{t('page.create_child')} #{elem.title}", :class=>'button new'
      
      # Если дочерние элементы отсутствуют
      if has_no_childs
        delete=  link_to('', page_path(elem.zip), :method=>:delete, :title=>"#{t('page.delete')} #{elem.title}", :confirm=>t('page.delete_confirm'), :class=>'button delete') 
      else
        delete=  link_to('', '#',  :title=>t('page.sub_sections_must_be_deleted'), :class=>'button undeleted', :onclick=>"javascript:alert('#{t('page.sub_sections_must_be_deleted')}');return false;")
      end
          
      up+down+edit+new+delete
    end
    
    def manager_pages_tree!(tree, options= {})
      result= ''
      
      # Значения по умолчанию или полученные из массива опций
      node=   options[:node]  ? options[:node]  : nil
      root=   options[:root]  ? options[:root]  : false
      first=  options[:first] ? options[:first] : false
      last=   options[:last]  ? options[:last]  : false
              
      #Предположим - пришел корень
      unless node
        # Выбераем из дерева корневые элементы
        roots= tree.select{ |elem| elem.parent_id == nil }
        # Узнаем id первого и последнего элементов массива
        roots_first_id= roots.empty? ? nil : roots.first.id
        roots_last_id=  roots.empty? ? nil : roots.last.id

        # Отрисовать каждый элемент
        # И его дочерние элементы
        roots.each do |root|
          # Если id элемента который мы рисуем совпал с id первого или последнего элементов
          # То соответствено устанавливаем флаг :first или :last
          # Требуется для отрисовки стрелок вверх/вниз, или их блокировки
          result<< manager_pages_tree!(tree, :node=>root, :root=>true, :first=>(root.id==roots_first_id), :last=>(root.id==roots_last_id))
        end
      else
        res= ''
        child_res= ''
        # Имеем узел
        # узнать кол-во дочерних элементов данного узла
        # Это нужно для того, что бы узнать - стоит ли рисовать кнопку удаления (узел у которого есть дочерние страницы - не удаляем!)
        childs= tree.select{ |elem| elem.parent_id == node.id }
        # Блок с элементами управления
        # Здесь уже должно быть известно - первый элемент или последний
        # Флаги для admin_controls поступают из рекурсии верхнего уровня
        res<< content_tag(:div, admin_controls(node, :childs=>childs.size.zero?, :first=>first, :last=>last), :class=>:controls) #|up, down, delete, edit, new|
        # Блок с названием страницы (ссылка)
        
        link_txt=  node.title
        link_txt= Sanitize.clean(link_txt , SatitizeRules::Config::TITLE)
        link_txt = 'Имя не определено' if link_txt.blank?
        
        res<< content_tag(:div, link_to(link_txt, page_path(node.zip), :title=>t('page.zip_of_page') + "#{node.zip}"), :class=>"link #{'root' if root}")
        # Обернуть в один блок
        res= content_tag(:div, res, :class=>:elem)
        # Получить id узла
        node_id= node.id
        # Удаляем узел из дерева, при следующей рекурсии придется обходить меньше элементов =)
        # Оптимизатор хренов =)
        tree.delete(node)
        
        # Узнаем id первого и последнего элементов массива дочерних элементов
        childs_first_id= childs.empty? ? nil : childs.first.id
        childs_last_id=  childs.empty? ? nil : childs.last.id
        
        # Делаем все тоже самое для дочерних. Отрисуем дочерний элемент, и все дочерние
        childs.each do |elem|
          # Если id элемента который мы рисуем совпал с id первого или последнего элементов
          # То соответствено устанавливаем флаг :first или :last
          # Требуется для отрисовки стралов вверх/вниз, или их блокировки
          child_res << manager_pages_tree!(tree, :node=>elem, :first=>(elem.id==childs_first_id), :last=>(elem.id==childs_last_id) )
        end
        
        # Если есть дочерние - обернем их
        child_res= child_res.blank? ? '' : content_tag(:div, child_res, :class=>:childs)
        result<<(res + child_res)
      end #unless node
      result
    end
    #-------------------------------------------------------------------------------------------------------
    # ~Страница - Карта редактора
    #-------------------------------------------------------------------------------------------------------
    
    
    #-------------------------------------------------------------------------------------------------------
    # Страница - Карта страниц сайта
    #-------------------------------------------------------------------------------------------------------
        
    def pages_tree!(tree, options= {})
      result= ''
      # Значения по умолчанию или полученные из массива опций
      node=   options[:node]  ? options[:node]  : nil
      root=   options[:root]  ? options[:root]  : false
      unless node                                                                                             # Предположим - пришел корень
        roots= tree.select{ |elem| elem.parent_id == nil }                                                    # Выбераем из дерева корневые элементы
        roots.each { |root| result<< pages_tree!(tree, :node=>root, :root=>true) }                            # Отрисовать каждый элемент и его дочерние элементы
      else
        res= content_tag :li, link_to( node.title, page_path(node.zip), :title=>t('page.zip_of_page')+"#{node.zip}"), :class=>(root ? 'root' : '')
        child_res= ''
        childs= tree.select{ |elem| elem.parent_id == node.id }                                               # Получаем дочерние элементы узла
        tree.delete(node)                                                                                     # Удаляем узел из дерева, при следующей рекурсии придется обходить меньше элементов =)
        childs.each {|elem| child_res << pages_tree!(tree, :node=>elem) }                                     # Делаем все тоже самое для дочерних. Отрисуем дочерний элемент, и все дочерние
        child_res= child_res.blank? ? '' : (content_tag :li, (content_tag :ul, child_res))                    # Если есть дочерние - обернем их
        result<<(res + child_res)
      end #unless node
      result
    end
    
    #-------------------------------------------------------------------------------------------------------
    # ~Страница - Карта страниц сайта
    #-------------------------------------------------------------------------------------------------------
  
  #-------------------------------------------------------------------------------------------------------
  # ~Nested Set View Helpers
  #-------------------------------------------------------------------------------------------------------
  
end
