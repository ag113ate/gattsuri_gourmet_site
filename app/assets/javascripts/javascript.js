$(function(){
  
  // 背景画像をスライドで表示
  (function(){
    // 表示サイズの設定（画面サイズに合わせる）
    var disp_height = $(window).height();
    var disp_width = $(window).width();
    var setting_str = disp_width + 'px' + ' ' + disp_height + 'px';
    $('body').css('background-size', setting_str);
    
    // スライド処理の設定
    $('body').bgSwitcher({
        images: [
          '/images/hamburger.jpg',
          '/images/ramen.jpg',
          '/images/tempura_bowl.jpg'], // 切替背景画像を指定
    });
  })();
});