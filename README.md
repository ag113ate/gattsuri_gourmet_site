### ■ サイト内容
ガッツリ系のメニュー提供を行う店舗を紹介するグルメサイト
  
※　本アプリは、以下サービスを利用しており、御自身でAPIキー等を取得する必要があります。<br>
・ぐるなびWebサービスのAPIキー  
・GoogleのMaps JavaScript APIキー  
・Amazon S3のアクセスキー等
（Heroku等の環境で使用する場合のみ）  

### ■使用方法  
ローカルにリポジトリをクローン、あるいはダウンロードした後に以下の作業を行ってください。  
1. bundle install --without production
1. rake db:migrate  
1. rake db:seed
1. 「~/.bash_profile」等に以下の環境変数を設定してください。  
    GNAVI_API_KEY='$YOUR_GNAVI_API_KEY'  
    MAP_API_KEY='$YOUR_GOOGLE_API_KEY'  
    
    （以下は、Heroku等の環境で使用する場合のみ設定）  
    AWS_ACCESS_KEY='$YOUR_AWS_ACCESS_KEY'  
    AWS_SECRET_KEY='$YOUR_AWS_SECRET_KEY'  
    AWS_REGION='$YOUR_AWS_REGION'  
    S3_BUCKET_NAME='$YOUR_S3_BUCKET_NAME'  
    
    ※  ・$YOUR_GNAVI_API_KEYは、グルナビWebサービスで取得したAPIキーを設定してください。  
    　 ・$YOUR_GOOGLE_API_KEYはGoogleのAPIキーを設定してください。  
    　 ・$YOUR_AWS_ACCESS_KEY、$YOUR_AWS_SECRET_KEY、$YOUR_AWS_REGION、  
    　　 $YOUR_S3_BUCKET_NAMEは、Amazon S3の情報を設定してください。
       
1. 対象の都道府県の店舗情報を取得  
    rake get_gnavi_api_data［pref_code］   
      ※ pref_codeには店舗情報を取得したい都道府県コードを設定します。  
      　（現在は、関東地域のみの対応となっております）  
    　    設定するコード値については、ぐるなびWebサービスの「都道府県マスタAPI」  
      　  を利用し、参照してください。

以上で作業は完了です。サーバーを起動してください。
      
