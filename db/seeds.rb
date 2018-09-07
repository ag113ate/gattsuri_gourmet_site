# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

store = Store.create(store_id: "r421602",
                     name: "やみつき餃子とがっつりチキン キンハイ",
                     review: "3.5",
                     opentime: "月～木・日 17:00～24:00\n金・土・祝前日 17:00～翌1:00",
                     holiday: "不定休日あり」、「毎週日曜日\n※※日曜日は月曜祝日の場合営業",
                     tel: "050-3312-6210",
                     address: "〒105-0013\n東京都港区浜松町1-28-13\nムーンストリート大門6・7F",
                     line: "ＪＲ中央線",
                     station: "中野駅",
                     station_exit: "南口",
                     walk: 1,
                     latitude: 37.444964,
                     longitude: 138.855403,
                     category_name_l: "居酒屋",
                     shop_url: "https://r.gnavi.co.jp/bfj81ee00000/?ak=gFd702LTUOkdXai9d5QpyACyc8J2gyzQxIBqDR7by68%3D")

store.food_images.create(image_url: "hamburger.jpg")
