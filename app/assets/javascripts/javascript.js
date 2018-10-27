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


$(window).on('load page:load', function(){
  var controller_name = $('body').data('controller');
  var action_name = $('body').data('action');
  
  if (!( ((controller_name == "gourmet_sites") && (action_name == "disp_search_result")) ||
         ((controller_name == "users") && (action_name == "show")) )){
    return;
  }

  // 各変数の初期化
  var img_disp_areas = $('.store-image-area'); // 画像表示領域のオブジェクト
  var img_areas_num = img_disp_areas.length; //処理を行う領域数

  // 各画像領域に1枚画像を表示
  //（複数重なっている表示している画像を1枚のみ表示）
  (function(){
    //  1.  一旦、全ての料理画像を非表示
    $('.store-image-area').find('img').css('display', 'none');
    //  2.  各領域1枚のみ画像を表示（表示する画像を一番最初の画像）
    for (var loop1 = 0; loop1 < img_areas_num; loop1++){
      img_disp_areas.eq(loop1).find('img').eq(0).css('display', 'block');
    }
  })();
  
  
  // 料理画像をスライドで表示 
  (function(){
    var current_img_no = new Array(img_areas_num).fill(0);
    
    
    // スライド表示処理
    function changeSlides(imgs, img_num, img_area_no){
      // 次の表示画像の番号を求める
      var next_img_no = current_img_no[img_area_no] + 1;
      if (next_img_no >= img_num){
        next_img_no = 0;
      }
      
      imgs.eq(current_img_no[img_area_no]).fadeOut(2000);
      imgs.eq(next_img_no).fadeIn(2000);
      
      // 表示画像の番号を更新
      current_img_no[img_area_no] = next_img_no;
    }
    
    // ====================================================================
    // 　料理画像の各表示領域について、画像を切り替える間隔の設定や、
    //   各表示領域に用意されている画像枚数を取得
    // =========================== begin ==================================
    
    // 各変数を宣言
    var interval_msec = new Array(img_areas_num); // スライド表示する間隔
    var areas_imgs = new Array(img_areas_num); // 各領域に対しての複数枚の画像
    var areas_imgs_num = new Array(img_areas_num); // 各領域に用意されている画像枚数
    
    // 各情報を設定
    for (var loop1 = 0; loop1 < img_areas_num; loop1++){
      // スライド表示する間隔を設定（各領域の間隔は乱数により3～6秒に設定）
      interval_msec[loop1] = Math.floor((Math.random() * (6 - 3) + 3) * 1000);
      
      // 各領域の画像オブジェクトを取得
      areas_imgs[loop1] = img_disp_areas.eq(loop1).find('img');
      
      // 各領域に用意されている画像枚数を取得
      areas_imgs_num[loop1] = areas_imgs[loop1].length;
    }
    // ============================ end ===================================
    
    // スライド表示関数を呼び出し
    for (var loop1 = 0; loop1 < img_areas_num; loop1++){
      if (areas_imgs_num[loop1] == 1){
        continue;
      }
      (function(area_no){
        setInterval(function(){changeSlides(
          areas_imgs[area_no],
          areas_imgs_num[area_no],
          area_no)},
          interval_msec[area_no]);
      })(loop1);
    }
  })();
});
