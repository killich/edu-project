function show_editor_block(){
  $('current_editor_bar').hide();
  Effect.BlindDown('current_editor_block', { duration: 0.7 });
}
function hide_editor_block(){
  Effect.BlindUp('current_editor_block', { duration: 0.7 });
  Element.show.delay(0.7, 'current_editor_bar');
}
function  show_add_file_form(){
  $('add_file_link').hide();
  Effect.BlindDown('add_file_form', { duration: 0.5 });
    //Effect.BlindUp('question_block', { duration: 0.7 }); Element.show.delay(0.7, 'question_shower'); 
    //$('#question_block').show("blind", { direction: "vertical" }, 500);
    //Effect.BlindUp('question_block', { duration: 0.7 }); Element.show.delay(0.7, 'question_shower'); 
}

