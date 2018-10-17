$(function(){
  disp_score_icon();
  
  $("#input_review_total_score").change(function(){
    disp_score_icon();
  });
});

function disp_score_icon(){
  var score = $('#input_review_total_score').val();
  var img_list = $("#input_review_score_disp img");
  
  if (score != ''){
    /* ========================================== */
    /* 評価が選択された場合は、対応する画像を表示 */
    /* ========================================== */
    for (var loop1 = 1; loop1 <= img_list.length; loop1++){
      var img = img_list.eq(loop1 - 1);
      
      img.removeClass('disp_none');

      if (loop1 <= score){
        img.attr('src', '/assets/meat_color_all.png');
      }
      else if((loop1 - 0.5) <= score){
        img.attr('src', '/assets/meat_color_half.png');
      }
      else{
        img.attr('src', '/assets/meat_color_none.png');
      }
    }
    /* ========================================== */
  }else{
    /* 未選択となった場合は、画像を非表示 */
    for (var loop1 = 0; loop1 < img_list.length; loop1++){
      img_list.eq(loop1).addClass('disp_none');
    }
  }
}
