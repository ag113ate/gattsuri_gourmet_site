# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "csv"

CSV_FILE_NAME = "db/kanto_city_data.csv"

COLUMN_PREF = "prefecture"
COLUMN_DESIGN_CITY = "designated_cities"
COLUMN_CITY = "city"

pref_codes = {茨城県: 8, 栃木県: 9, 群馬県:10, 
              埼玉県:11, 千葉県:12, 東京都:13, 神奈川県:14}

CSV.read(CSV_FILE_NAME, headers: true).each do |row|
  
  if ((row[COLUMN_DESIGN_CITY] == nil) && (row[COLUMN_CITY] != nil))
    # ============================================================
    # ケース1. 政令指定都市等ではない場合(例：東京都千代田区)
    # ============================================================
    City.create(pref_code: pref_codes[row[COLUMN_PREF].to_sym], # 都道府県コード
                pref_name: row[COLUMN_PREF], # 都道府県名
                city_name: row[COLUMN_CITY], # 市区町村名
                is_designated_cities: "false") # 政令指定都市等か
                
  elsif ((row[COLUMN_DESIGN_CITY] != nil) && (row[COLUMN_CITY] == nil))
    # ============================================================
    # ケース2. 政令指定都市等の場合(例：神奈川県横浜市)
    # ============================================================
    
    # 政令指定都市等の場合、先に「ケース2」の処理が実行される想定だが、csvデータの
    # 並び順によっては、先に「ケース3」が実行される場合もある
    # その場合、ここの処理は不要となる
    city = City.find_by(city_name: row[COLUMN_DESIGN_CITY])
    if (city != nil)
      next
    end
    
    City.create(pref_code: pref_codes[row[COLUMN_PREF].to_sym], # 都道府県コード
                pref_name: row[COLUMN_PREF], # 都道府県名
                city_name: row[COLUMN_DESIGN_CITY], # 市区町村名
                is_designated_cities: "true") # 政令指定都市等か
                
  elsif ((row[COLUMN_DESIGN_CITY] != nil) && (row[COLUMN_CITY] != nil))
    # ============================================================
    # ケース3. 政令指定都市等の市区町村の場合（例：神奈川県横浜市「鶴見区」）
    # ============================================================
    city = City.find_by(city_name: row[COLUMN_DESIGN_CITY])
    
    # このケースのデータが読み込まれた場合、「ケース2」の処理が実行済みの想定だが、
    # csvデータの並び順によっては、先に「ケース3」が実行される場合もある
    # その場合に対応
    if (city == nil)
      city = City.create(pref_code: pref_codes[row[COLUMN_PREF].to_sym], # 都道府県コード
                         pref_name: row[COLUMN_PREF], # 都道府県名
                         city_name: row[COLUMN_DESIGN_CITY], # 市区町村名
                         is_designated_cities: "true") # 政令指定都市等か
    end
    
    city.sub_cities.create(sub_city_name: row[COLUMN_CITY])
    
  end

end