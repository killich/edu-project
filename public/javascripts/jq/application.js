function show_editor_block(){
  $('#current_editor_bar').hide("blind", { direction: "vertical" }, 500);
  $('#current_editor_block').delay(500).show("blind", { direction: "vertical" }, 700);
}
function hide_editor_block(){
  $('#current_editor_block').hide("blind", { direction: "vertical" }, 700);
  $('#current_editor_bar').delay(700).show("blind", { direction: "vertical" }, 500);
}
function show_add_file_form(){  
  $('#add_file_link').hide();
  $('#add_file_form').show("blind", { direction: "vertical" }, 500);
}
function show_question_form(){
    $('#question_shower').hide("blind", { direction: "vertical" }, 300);
    $('#question_block').delay(300).show("blind", { direction: "vertical" }, 500);
}
function hide_question_form(){
    $('#question_block').hide("blind", { direction: "vertical" }, 500);
    $('#question_shower').delay(500).show("blind", { direction: "vertical" }, 500);
}
/*  try
    block_id
    block_id_show_link
    block_id_hide_link
*/
function show_block(id){
    var id_name = '#' + id;
    var show_link = id_name + '_show_link';
    var hide_link = id_name + '_hide_link';
    $(show_link).hide();
    $(hide_link).show();
    $(id_name).show("blind", { direction: "vertical" }, 500);
}
function hide_block(id){
    var id_name = '#' + id;
    var show_link = id_name + '_show_link';
    var hide_link = id_name + '_hide_link';
    $(hide_link).hide();
    $(show_link).show();
    $(id_name).hide("blind", { direction: "vertical" }, 500);
}
function show_version_block(){
    $('#show_version_link').hide();
    $('#hide_version_link').show();
    $('#version').show("blind", { direction: "vertical" }, 500);
}
function hide_version_block(){
    $('#hide_version_link').hide();
    $('#show_version_link').show();
    $('#version').hide("blind", { direction: "vertical" }, 500);
}
function show_anti_msie_declaration(){
  $('#anti_msie_declaration').show("blind", { direction: "vertical" }, 1000);
}
function anti_msie_declaration_close(){
  $('#anti_msie_declaration').hide("blind", { direction: "vertical" }, 1000);
}
function browser_select(){
  $('#anti_msie_declaration_txt').hide("blind", { direction: "vertical" }, 500);
  $('#browser_select').delay(500).show("blind", { direction: "vertical" }, 500);
}
function show_markup(){
  $('#html_preview_block').hide();  
  $('#markup_help_block').hide();  
  $('#markup_preview_block').show();
}
function show_markup_help(){
  $('#html_preview_block').hide();  
  $('#markup_preview_block').hide();  
  $('#markup_help_block').show();
}
function show_html(){
  if(jQuery.browser.msie && (jQuery.browser.version == 6)){alert('Увы. Ничего не получится. Вы используете Internet Explorer 6.'); return false;}
  
  $('#markup_preview_block').hide();
  $('#markup_help_block').hide();
  $('#html_preview_block').show();  

  jQuery.ajax({
    type: "POST",
    url: "/pages/textiletest",
    data: {textile_text: $('#page_content').val()},
    dataType: "html",
    success: function(data, status, xhr){
      // Вставить данные
      $('#html_preview').html(data);
    },
    beforeSend: function(xhr){
      //Показать символ загрузки
      $('#html_preview').html('<div class="ajax_loader"><img src="/images/basic/ajax.gif" alt="Идет загрузка данных с сервера с помощью технологии AJAX (АЯКС)" /></div>');
    },
    complete: function(xhr, status){
      //Убрать символ загрузки
    },
    error: function(xhr, status, error){
      alert("Технология АЯКС. \nСерверная ошибка или ошибка соединения с Интернет.");
      $('#html_preview').html("Технология АЯКС.<br />Серверная ошибка или ошибка соединения с Интернет.<br />Сообщите о проблеме на адрес электронной почты: iv-schools@yandex.ru");
    }
  });//jQuery.ajax
}//textile2html

function html2textile(){
  if(jQuery.browser.msie && (jQuery.browser.version == 6)){alert('Увы. Ничего не получится. Вы используете Internet Explorer 6.'); return false;}
  jQuery.ajax({
    type: "POST",
    url: "/pages/htmltest",
    data: {html2textile_text: $('#html2textile_text').val()},
    dataType: "html",
    success: function(data, status, xhr){
      $('#test').html(data);
    },
    beforeSend: function(xhr){
      $('#test').html('<img src="/images/basic/ajax.gif" alt="AJAX загрузка данных" />');
    },
    complete: function(xhr, status){
      //alert('ok!');
    },
    error: function(xhr, status, errorThrown){
      alert('oops!');
    }
  });//jQuery.ajax
}//html2textile