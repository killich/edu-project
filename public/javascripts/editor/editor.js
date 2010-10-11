function insertFormatTeg3(obj_id, elem){
	var idTextArea=obj_id;
	var text_area = document.getElementById(idTextArea);
	text= "";
	
	// Вставка
	switch (elem){   
		case 'img':
			/* Эта фокусировка на текстовое поле ввода помогает производить вставку куда предполагается */
			document.getElementById('page_content').focus();
			
			img= prompt( "Укажите адрес изображения на сервере", "АДРЕС ИЗОБРАЖЕНИЯ" );
			alt= prompt( "Введите описание изображения", "Мое изображение" );
			text= "\n<img src=\""+img+"\" alt=\""+alt+"\" title=\""+alt+"\" />\n";
			break;
		case 'file':
			document.getElementById('page_content').focus();
			
			path= prompt( "Укажите путь к файлу (В сети Интернет или на сервере)", "ПУТЬ К ФАЙЛУ" );
			alt= prompt( "Введите описание файла", "Важный файл с информацией" );
			name= prompt( "Введите название файла", "Файл" );
			text= "\n<a href=\""+path+"\" alt=\""+alt+"\" title=\""+alt+"\" >"+name+"</a>\n";
			break;
		case 'inet':
			document.getElementById('page_content').focus();
			
			path= prompt( "Укажите путь к Интернет странице (не удаляйте - http://)", "http://www.iv-schools.ru" );
			alt= prompt( "Введите описание страницы", "Интернет страница с интересной информацией" );
			name= prompt( "Введите название страницы", "Интернет страница" );
			text= "\n<a href=\""+path+"\" alt=\""+alt+"\" title=\""+alt+"\" >"+name+"</a>\n";
			break;
		case 'email':
			document.getElementById('page_content').focus();
			
			email= prompt( "Укажите Адрес Электронной почты", "blabla@babla.ru" );
			alt= prompt( "Описание ссылки на электронную почту", "Адрес электронной почты" );
			name= prompt( "Кому будет отправлено письмо", "Иванов И.И." );
			text= "\n<a href=\"mailto:"+email+"\"= alt=\""+alt+"\" title=\""+alt+"\" >"+name+"</a>\n";
			break;
	}
	
	// Форматирование
	switch (elem){  
		case 'p':
			text= "\n<p>\n\tТекст абзаца\n</p>\n";
			break;
		case 'br':
			text= "\n<br />\n";
			break;
		case 'hr':
			text= "\n<hr />\n";
			break;
		case 'center':
			text= "\n<center>В центре</center>\n";
			break;
		case 'b':
			text= "\n<b>Жирный шрифт</b>\n";
			break;
		case 'i':
			text= "\n<i>Курсив</i>\n";
			break;
		case 'u':
			text= "\n<u>Подчеркнутый</u>\n";
			break;
	}
	
	// Заголовки
	switch (elem){   
		case 'h1':
			document.getElementById('page_content').focus();
			
			header= prompt( "Введите заголовок", "Заголовок" );
			if(header=='')header=' ';
			text= "\n<h1>"+header+"</h1>\n";
			break;
		case 'h2':
			document.getElementById('page_content').focus();
			
			header= prompt( "Введите заголовок", "Заголовок" );
			if(header=='')header=' ';
			text= "\n<h2>"+header+"</h2>\n";
			break;
		case 'h3':
			document.getElementById('page_content').focus();
			
			header= prompt( "Введите заголовок", "Заголовок" );
			if(header=='')header=' ';
			text= "\n<h3>"+header+"</h3>\n";
			break;
		case 'h4':
			document.getElementById('page_content').focus();
			
			header= prompt( "Введите заголовок", "Заголовок" );
			if(header=='')header=' ';
			text= "\n<h4>"+header+"</h4>\n";
			break;
	}
	
	// Заголовки
	switch (elem){   
		case 'ul':
			text= "\n<ul>\n\t<li>Элемент 1</li>\n\t<li>Элемент 2</li>\n\t<li>Элемент 3</li>\n</ul>\n";
			break;
		case 'ol':
			text= "\n<ol>\n\t<li>Элемент 1</li>\n\t<li>Элемент 2</li>\n\t<li>Элемент 3</li>\n</ol>\n";
			break;
	}
	
	// Алгоритм вставки для разных браузеров	
    if (document.selection){
		text_area.focus();
		sel= document.selection.createRange();
		sel.text= text;
    }
    else if (text_area.selectionStart || text_area.selectionStart == "0"){	
        var startPos = text_area.selectionStart;
        var endPos = text_area.selectionEnd;
        var chaineText = text_area.value;

        text_area.value = chaineText.substring(0, startPos) + text + chaineText.substring(endPos, chaineText.length);
    }else{
        text_area.value += text;
    }
}