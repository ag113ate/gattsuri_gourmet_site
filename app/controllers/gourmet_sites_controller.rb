class GourmetSitesController < ApplicationController
  def top
  end

  def disp_search_result
    @area = params[:area]
    
    @name = "やみつき餃子とがっつりチキン キンハイ"
    #@name = "やみつき餃子"
    @opentime = "月～木・日 17:00～24:00\n金・土・祝前日 17:00～翌1:00"
    @holiday = "不定休日あり」、「毎週日曜日\n※※日曜日は月曜祝日の場合営業"
    @tel = "050-3312-6210"
    #@adress = "〒221-0835 神奈川県横浜市神奈川区鶴屋町2-16-2"
    # @adress = "〒279-0031 千葉県浦安市舞浜1-6 サンルートプラザ東京9F"
    @adress = "〒105-0013\n東京都港区浜松町1-28-13\nムーンストリート大門6・7F"
    @line = "ＪＲ中央線"
    @station = "中野駅"
    @station_exit = "南口"
    @walk = "1"
    @access = "#{@line} #{@station} #{@station_exit} 徒歩#{@walk}分"
    
    @category_name_l = "居酒屋"
    @shop_url = "https://r.gnavi.co.jp/bfj81ee00000/?ak=gFd702LTUOkdXai9d5QpyACyc8J2gyzQxIBqDR7by68%3D"
    
    @review = 2.8
  end
end
