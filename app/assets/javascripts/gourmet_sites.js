$(function(){
  $(".select-city-btn").mouseover(function(){
    $(this).css('background', 'orange');
    $(this).css('color', 'white');
  });
  
  $(".select-city-btn").mouseout(function(){
    $(this).css('background', 'rgba(255, 255, 255, 0.5)');
    $(this).css('color', '');
  });
});
