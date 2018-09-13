# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

store = Store.create(store_id: "kcyx001",
                     name: "フジオ軒 お茶の水ワテラス店",
                     review: "3.5",
                     opentime: "11:30～14:30、17:00～22:00",
                     holiday: "不定休日あり ※テナントに準ずる",
                     tel: "050-3312-6210",
                     address: "〒101-0063\n東京都千代田区神田淡路町2-105\nワテラスアネックス3F",
                     line: "地下鉄丸ノ内線",
                     station: "淡路町駅",
                     station_exit: "",
                     walk: 3,
                     latitude: 35.697529,
                     longitude: 139.767959,
                     category_name_l: "手作り洋食とビール",
                     shop_url: "https://r.gnavi.co.jp/p5yhvgsu0000/?ak=gFd702LTUOkdXai9d5QpyACyc8J2gyzQxIBqDR7by68%3D")
store.food_images.create(image_url: "hamburger.jpg")


store = Store.create(store_id: "a010916",
                     name: "鉄板ダイニング 中野グリル",
                     review: "4.5",
                     opentime: "月～日 11:00～23:00(L.O.22:00)",
                     holiday: "不定休日あり ※(丸井定休日に準ずる)",
                     tel: "03-5328-2920",
                     address: "〒164-0001\n東京都中野区中野3-34-28\n中野マルイ5F",
                     line: "ＪＲ中央線",
                     station: "中野駅",
                     station_exit: "南口",
                     walk: 1,
                     latitude: 35.704766,
                     longitude: 139.665138,
                     category_name_l: "焼き鳥・肉料理・串料理",
                     shop_url: "https://r.gnavi.co.jp/a010916/?ak=gFd702LTUOkdXai9d5QpyACyc8J2gyzQxIBqDR7by68%3D")
store.food_images.create(image_url: "hamburger.jpg")


store = Store.create(store_id: "gdts011",
                     name: "MEAT FAB’s 4041 （ミートファブズ）",
                     review: "3.0",
                     opentime: "11:30～23:00(L.O.22:00)",
                     holiday: "不定休日あり",
                     tel: "050-3313-4488",
                     address: "〒190-0012\n東京都立川市曙町2-7-5\n1F",
                     line: "ＪＲ",
                     station: "立川駅",
                     station_exit: "北口",
                     walk: 1,
                     latitude: 35.699571,
                     longitude: 139.413688,
                     category_name_l: "和食",
                     shop_url: "https://r.gnavi.co.jp/cta93xvy0000/?ak=gFd702LTUOkdXai9d5QpyACyc8J2gyzQxIBqDR7by68%3D")
store.food_images.create(image_url: "hamburger.jpg")
