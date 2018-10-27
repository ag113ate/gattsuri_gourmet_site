/* 対象セレクタの位置、幅、マージン値を取得 */
function getPosition($selector){
  offset_top = $selector.offset().top +  $selector.outerHeight();
  
  pos_left = $selector.offset().left;
  pos_top = $('#header').height();
  
  width = $selector.width();
  
  margin = $selector.css('margin');
  
  var obj = {
    offset_top: offset_top,
    
    pos_left: pos_left,
    pos_top: pos_top,
    
    width: width,
    
    margin: margin
  }
  
  return obj;
}


/* 固定表示の設定 */
function setFixedDisp($selector, obj){
  $selector.css('position', 'fixed');
  $selector.css('width', obj.width);
  $selector.css('left', obj.pos_left);
  $selector.css('top', obj.pos_top);
  $selector.css('margin', '0 0 0 0');
  $selector.css('z-index', 20);
  
  $selector.css('-webkit-border-radius','0px');
  $selector.css('-moz-border-radius', '0px');
  $selector.css('border-radius', '0px');
}


/* 固定表示の解除 */
function unsetFixedDisp($selector, obj){
  $selector.css('position', '');
  $selector.css('width', '');
  $selector.css('left', '');
  $selector.css('top', '');
  $selector.css('margin', obj.margin);
  $selector.css('z-index', '');
  
  $selector.css('-webkit-border-radius','10px');
  $selector.css('-moz-border-radius', '10px');
  $selector.css('border-radius', '10px');
}


/* お気に入り店舗の削除確認画面の表示 */
function disp_bookmark_delete_confirm(_this){
  /* 表示領域の調整 */
  (function(){
    if ($('#bookmark_modal').width() < 500){
      $('#bookmark_modal').css('width', '500');
    }

    if ($('#bookmark_modal').height() < 200){
      $('#bookmark_modal').css('height', '200');
    }
  })();
  
  /* 表示位置の設定　*/
  (function(_this){
    /* ページの真中に表示されるよう、左、上位置を設定 */
    var left = ($(window).width()  - $('#bookmark_modal').width() ) / 2;
    var top  = ($(window).height() - $('#bookmark_modal').height()) / 2;
  
    /* トップ、レフトの位置とも0以上とする                               */
    /* （モーダルウィンドウのサイズ > 表示サイズ）となっている場合の対策 */
    left = (left >= 0) ? (left) : (0);
    top = (top >= 0) ? (top) : (0);
    
    $('#bookmark_modal').css('left', left);
    $('#bookmark_modal').css('top', top);
  })();

  /* 対象店舗の表示位置を取得　*/
  var index = $('.bookmark-delete').index(_this);
  
  /* 店舗名の表示 */
  $store_name_area = $("[id^='store_area_']").eq(index).find('.store-name-area');
  $('#bookmark_modal_title span').text($store_name_area.text());
  
  /* ----------------------------------------------------- */
  /*        「削除」ボタンのリンク先を作成                 */
  /* ------------------- start---------------------------- */
  
  /* 店舗IDを取得                                          */
  /* 例： str = split('store_area_gec0501')                */
  /*      str[0] => store, str[1] => area,                 */
  /*      str[2] => gec0501                                */
  split_str = $("[id^='store_area_']").eq(index).attr('id').split('_');
  
  /* リンクの設定 */
  link_str = "/gourmet_sites/bookmark/" + split_str[2];
  $('#bookmark_delete_btn').attr('href', link_str);
  /* -------------------- end ---------------------------- */
  
  /* オーバーレイ、モーダルウィンドウを表示 */
  $('#overlay').css('display', 'block');
  $('#bookmark_modal').css('display', 'block');
}


/* 投稿口コミの削除確認画面の表示 */
function disp_review_delete_confirm(_this){
  /* 対象となるレビュー情報をモーダルウィンドゥ内に設定 */
  (function(_this){
    var index = $('.review_delete_btn').index(_this);
    var $target_review = $("[id^='show_review_vote_']").eq(index);
    
    /* 幅の設定                                                    */
    /* （モーダルウィンドウには「投稿口コミ欄の幅 + 40px」を設定 ）*/
    /*                              ※ 左右：20pxずつ余白          */
    $('#review_modal_info_disp').width($target_review.width());
    $('#review_modal').width($target_review.width() + 20);
    
    /* レビュー情報をモーダルウィンドウ内に設定 */
    var html_data = $target_review.html();
    $('#review_modal_info_disp').html(html_data);
    
    /* フッター部分（「口コミを編集」、「口コミを削除」等のボタン）は不要 */
    $('#review_modal .show-review-footer').remove();
    $('#review_modal .show-review-footer').css('display', 'none');
    
  })(_this);
  
  /* 表示位置の設定　*/
  (function(_this){
    /* ページの真中に表示されるよう、左、上位置を設定 */
    var left = ($(window).width()  - $('#review_modal').width() ) / 2;
    var top  = ($(window).height() - $('#review_modal').height()) / 2;
  
    /* トップ、レフトの位置とも0以上とする                               */
    /* （モーダルウィンドウのサイズ > 表示サイズ）となっている場合の対策 */
    left = (left >= 0) ? (left) : (0);
    top = (top >= 0) ? (top) : (0);
    
    $('#review_modal').css('left', left);
    $('#review_modal').css('top', top);
  })();

  /* 「削除」ボタンのリンク先を作成  */
  (function(_this){
    var index = $('.review_delete_btn').index(_this);
    
    /* 投稿IDを取得                                          */
    /* 例： str = split('show_review_vote_a116402_283639')   */
    /*      str[0] => show, str[1] => review, str[2] => vote */
    /*      str[3] => a11640, str[4] => 283639               */
    split_str = $("[id^='show_review_vote_']").eq(index).attr('id').split('_');
    
    /* リンクの設定 */
    link_str = "/reviews/" + split_str[3] + "/" + split_str[4];
    $('#review_delete_btn').attr('href', link_str);
  })(_this);
  
  /* オーバーレイ、モーダルウィンドウを表示 */
  $('#overlay').css('display', 'block');
  $('#review_modal').css('display', 'block');
}


$(function(){
  var controller_name = $('body').data('controller');
  var action_name = $('body').data('action');
  
  if (!( (controller_name == "users") && (action_name == "show") )){
    return;
  }

  /* サイドバーについて、幅を設定                              */
  /* ※ サイドバーは固定表示しているためJQueryにより幅を設定   */
  $('#user_info').css('width', $('side_bar').width());
  $('#user_id_disp').css('width', $('#side_bar').width());

  /* ====================================================================== */
  /*     「キャンセル」、「削除」ボタンをクリックした時の動作               */
  /* ============================= start ================================== */
  $('#modal_window_close_btn, #bookmark_delete_btn, #review_delete_btn').on('click', function(){
    /* モーダルウインドウ、オーバーレイ表示を閉じる */
    $('#overlay').css('display', 'none');
    
    /* 「お気に入り店舗」、あるいは「投稿口コミ」表示されている方の */
    /* モーダルウィンドウを閉じる                                   */
    if ($('#bookmark_modal').css('display') == 'block'){
      $('#bookmark_modal').css('display', 'none');
    }else if($('#review_modal').css('display') == 'block'){
      $('#review_modal').css('display', 'none');
    }
  
    /* 表示位置の設定                                            */
    /* ※  固定表示していたモーダルウィンドウを閉じた際に        */
    /*    ページの上部にスクロールされるため                     */
    /*    scrollTop関数が効かないため、animate関数を利用         */      
    var position = $(window).scrollTop();
    $("body,html").animate({scrollTop:position}, 1, "linear");
  });
  /* ============================== end =================================== */
  
  
  /* ====================================================================== */
  /*         「お気に入り削除」ボタンをクリックした時の動作                 */
  /* ============================= start ================================== */
  $('.bookmark-delete').on('click', function(){
    /* オーバーレイ、モーダル表示 */
    disp_bookmark_delete_confirm(this);
    
    /* 表示位置の設定                                            */
    /* ※ モーダルウィンドウを固定表示しているため、そのままでは */
    /*    ページの上部にスクロールされるため                     */
    /*    scrollTop関数が効かないため、animate関数を利用         */
    var position = $(window).scrollTop();
    $("body,html").animate({scrollTop:position}, 1, "linear");
  });
  /* ============================== end =================================== */
  
  /* ====================================================================== */
  /*         「口コミを削除」ボタンをクリックした時の動作                   */
  /* ============================= start ================================== */
  $('.review_delete_btn').on('click', function(){
    /* オーバーレイ、モーダル表示 */
    disp_review_delete_confirm(this);
    
    /* 表示位置の設定                                            */
    /* ※ モーダルウィンドウを固定表示しているため、そのままでは */
    /*    ページの上部にスクロールされるため                     */
    /*    scrollTop関数が効かないため、animate関数��利用         */
    var position = $(window).scrollTop();
    $("body,html").animate({scrollTop:position}, 1, "linear");
  });
  /* ============================== end =================================== */
});


$(window).on('load page:load', function(){
  var controller_name = $('body').data('controller');
  var action_name = $('body').data('action');
  
  if (!( (controller_name == "users") && (action_name == "show") )){
    return;
  }

  /* 「お気に入り店舗一覧」タイトルについて     */
  var $bookmark_title = $('#bookmark_title');
  var bookmark_title_obj = getPosition($bookmark_title);
  
  /* 「投稿口コミ一覧」タイトルについて */
  $show_review_title = $('#show_review_title');
  show_review_title_obj = getPosition($show_review_title);
  
  $(window).scroll(function(){
    window_top = ($(window).scrollTop());
    // 「お気に入り店舗一覧」タイトルについて
    if (((window_top + bookmark_title_obj.pos_top) > bookmark_title_obj.offset_top) &&
         (window_top < (show_review_title_obj.offset_top - 300))){
      setFixedDisp($bookmark_title, bookmark_title_obj);
    }
    else{
      unsetFixedDisp($bookmark_title, bookmark_title_obj);
    }
    
    // 「投稿口コミ一覧」タイトルについて
    if ((window_top + show_review_title_obj.pos_top) > show_review_title_obj.offset_top){
      setFixedDisp($show_review_title, show_review_title_obj);
    }
    else{
      unsetFixedDisp($show_review_title, show_review_title_obj);
    }
  });
  
});
