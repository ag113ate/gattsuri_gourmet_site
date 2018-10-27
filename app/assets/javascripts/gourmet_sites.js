$(function(){
  var controller_name = $('body').data('controller');
  var action_name = $('body').data('action');
  
  if (!( (controller_name == "gourmet_sites") && (action_name == "select_city") )){
    return;
  }

  $(".select-city-btn").mouseover(function(){
    $(this).css('background', 'orange');
    $(this).css('color', 'white');
  });
  
  $(".select-city-btn").mouseout(function(){
    $(this).css('background', '');
    $(this).css('color', '');
  });
  
  $(".select-city-btn").click(function(){
    var area = $(this).find(".select-city-submit-val").text();
    $('input:hidden[name="area"]').val(area);
    $("#select_city_form").submit();
  });
});
