require "sinatra/base"
require "sinatra/reloader"
require "slim"
require 'dotenv'
require 'redis'
require 'pp'
require 'ne_api_sdk_ruby'

module DemoSite
  class App < Sinatra::Base

    # If you want to set password protection for a particular environment,
    # uncomment this and set the username/password:
    #if ENV['RACK_ENV'] == 'staging'
      #use Rack::Auth::Basic, "Please sign in" do |username, password|
        #[username, password] == ['theusername', 'thepassword']
      #end
    #end

    configure :development do
      register Sinatra::Reloader
    end

    configure do
      # Set your Google Analytics ID here if you have one:
      # set :google_analytics_id, 'UA-12345678-1'

      if ENV['RACK_ENV'] == 'development'
        AP_SERVER_HOST   = 'http://localhost'
        AP_SERVER_PORT   = '3000'
        AP_NE_SERVER_HOST = 'https://ne64.next-engine.com'
        AP_NE_SERVER_PORT = '80'

        CLIENT_ID = ENV['NE_API_CLIENT_ID']
        CLIENT_SECRET = ENV['NE_API_CLIENT_SECRET']
        END_POINT = 'ne_api_sdk_ruby'
        REDIRECT_PORT = '8088'
        REDIRECT_URL = 'https://localhost' +':'+ REDIRECT_PORT + '/' + END_POINT
      else
        AP_SERVER_HOST   = 'https://hcoss.healthy-com.com'
        AP_SERVER_PORT   = '80'
        AP_NE_SERVER_HOST = 'https://ne64.next-engine.com'
        AP_NE_SERVER_PORT = '80'

        CLIENT_ID = ENV['NE_API_CLIENT_ID']
        CLIENT_SECRET = ENV['NE_API_CLIENT_SECRET']
        END_POINT = 'ne_api_sdk_ruby'
        REDIRECT_PORT = '8088'
        REDIRECT_URL = 'https://localhost' +':'+ REDIRECT_PORT + '/' + END_POINT
      end

      if AP_SERVER_PORT == '80'
        set :ap_server, AP_SERVER_HOST
      else
        set :ap_server, AP_SERVER_HOST + ':' +AP_SERVER_PORT
        set :api_server, REDIRECT_URL
      end

      if AP_NE_SERVER_PORT == '80'
        set :ap_ne_server, AP_NE_SERVER_HOST
      else
        set :ap_ne_server, AP_NE_SERVER_HOST + ':' +AP_NE_SERVER_PORT
        set :api_server, REDIRECT_URL
      end


      set :layouts_dir, 'views/_layouts'
      set :partials_dir, 'views/_partials'

      Dotenv.load

      REDIS = Redis.new(
          host: ENV["REDIS_HOST"],
          port: ENV["REDIS_PORT"]
      )

      enable :sessions
      set :client, NeApiSdkRuby::NeApiClient.new(CLIENT_ID, CLIENT_SECRET,REDIRECT_URL)
    end

    helpers do
      def show_404
        status 404
        @page_name = '404'
        @page_title = '404'
        slim :'404', :layout => :with_sidebar,
                    :layout_options => {:views => settings.layouts_dir}
      end

      def client
        settings.client
      end

      def login
        if session['uid'].nil? and session['state'].nil?
          response = client.neLogin
          case response['result']
            when NeApiSdkRuby::NeApiClient::RESULT_SUCCESS
              p 'ログインしました'
            when NeApiSdkRuby::NeApiClient::RESULT_REDIRECT
              redirect response
            when NeApiSdkRuby::NeApiClient::RESULT_ERROR
              p 'ログインエラーが発生しました'
            else
              redirect response
          end
        else
          client.neLogin(session['uid'],session['state'])
        end
      end
    end


    not_found do
      show_404
    end


    # Redirect any URLs without a trailing slash to the version with.
    get %r{(/.*[^\/])$} do
      redirect "#{params[:captures].first}/"
    end


    get '/' do
      @page_name = 'home'
      @page_title = 'Home'
      slim :index,
        :layout => :full_width,
        :layout_options => {:views => settings.layouts_dir}
    end

    get '/inventory_reservation/' do
      @page_name = 'inventory_reservation'
      @page_title = '在庫引当'
      slim :delivery_method,
           :layout => :full_width,
           :layout_options => {:views => settings.layouts_dir}
    end

    get '/delivery_method/' do
      @page_name = 'delivery_method'
      @page_title = '便種振り分け'
      slim :delivery_method,
           :layout => :full_width,
           :layout_options => {:views => settings.layouts_dir}
    end

    get '/back_orders_list/' do
      @page_name = 'back_orders_list'
      @page_title = '受注残リスト印刷'
      slim :back_orders_list,
           :layout => :full_width,
           :layout_options => {:views => settings.layouts_dir}
    end

    get '/picking_list/' do
      @page_name = 'picking_list'
      @page_title = 'ピッキングリスト印刷'
      slim :picking_list,
           :layout => :full_width,
           :layout_options => {:views => settings.layouts_dir}
    end

    # Routes for pages that have unique things...

    get '/special/' do
      @page_name = 'special'
      @page_title = 'A special page'
      @time = Time.now
      slim :special,
        :layout => :with_sidebar,
        :layout_options => {:views => settings.layouts_dir}
    end

    get "/#{END_POINT}/" do
      session[:uid] = params['uid']
      session[:state] = params['state']

      if session['uid'].nil? and session['state'].nil?
        @api_status = 'APIサーバに未接続'
        login
      else
        @api_status = 'APIサーバに接続済'
      end

      slim :index,
           :layout => :full_width,
           :layout_options => {:views => settings.layouts_dir}
    end

    get "/#{END_POINT}/login_only/" do
      response = login
      @response_json = JSON.load(response.to_json)

      @page_name = 'login'
      @page_title = 'ログインサンプル'
      slim :index,
           :layout => :full_width,
           :layout_options => {:views => settings.layouts_dir}
    end

    get "/#{END_POINT}/api_find/company/" do
      #////////////////////////////////////////////////////////////////////////////////
      #// 契約企業一覧を取得するサンプル
      #////////////////////////////////////////////////////////////////////////////////
      under_contract_company = client.apiExecuteNoRequiredLogin('/api_app/company')
      @response_json = JSON.load(under_contract_company.to_json)
      arr = @response_json["data"]
      @data = Hash[*arr]

      @page_name = 'api_find_company'
      @page_title = '契約企業一覧取得サンプル'
      slim :index,
           :layout => :full_width,
           :layout_options => {:views => settings.layouts_dir}
    end

    get "/#{END_POINT}/api_find/user/" do
      #////////////////////////////////////////////////////////////////////////////////
      #// 利用者情報を取得するサンプル
      #////////////////////////////////////////////////////////////////////////////////
      user = client.apiExecute(session['uid'],session['state'],'/api_v1_login_user/info')
      @response_json = JSON.load(user.to_json)
      arr = @response_json["data"]
      @data = Hash[*arr]

      @page_name = 'api_find_user'
      @page_title = '利用者情報取得サンプル'
      slim :index,
           :layout => :full_width,
           :layout_options => {:views => settings.layouts_dir}
    end

    get "/#{END_POINT}/api_find/goods/" do
      #////////////////////////////////////////////////////////////////////////////////
      #// 商品マスタ情報を取得するサンプル
      #////////////////////////////////////////////////////////////////////////////////
      query = {}
      # 検索結果のフィールド：商品コード、商品名、商品区分名、在庫数、引当数、フリー在庫数
      query['fields'] = 'goods_id, goods_name, goods_type_name, stock_quantity, stock_allocation_quantity, stock_free_quantity'
      # 検索条件：商品コードがredで終了している、かつ商品マスタの作成日が2013/10/31の20時より前
      query['goods_id-like'] = '%red'
      query['goods_creation_date-lt'] = '2013-10-31 20:00:00'
      # 検索は0～50件まで
      query['offset'] = '0'
      query['limit'] = '50'

      # アクセス制限中はアクセス制限が終了するまで待つ。
      # (1以外/省略時にアクセス制限になった場合はエラーのレスポンスが返却される)
      query['wait_flag'] = '1'

      # 検索対象の総件数を取得
      goods_cnt = client.apiExecute(session['uid'],session['state'],'/api_v1_master_goods/count', query)
      # 検索実行
      goods = client.apiExecute(session['uid'],session['state'],'/api_v1_master_goods/search', query)

      @response_json = JSON.load(goods.to_json)
      arr = @response_json["data"]
      @data = Hash[*arr]

      @page_name = 'api_find_goods'
      @page_title = '商品マスタ情報取得'
      slim :index,
           :layout => :full_width,
           :layout_options => {:views => settings.layouts_dir}
    end

    # Catch-all for /something/else/etc/ pages which just display templates.
    get %r{/([\w\/-]+)/$} do |path|
      pages = {
        'help' => {
          :page_name => 'help',
          :title => 'Help',
        },
        'help/accounts' => {
          :page_name => 'help_accounts',
          :title => 'Accounts Help',
        },
        # etc
      }
      if pages.has_key?(path)
        @page_name = pages[path][:page_name]
        @page_title = pages[path][:title]
        layout = :with_sidebar
        if pages[path].has_key?(:layout)
          layout = pages[path][:layout].to_sym
        end
        slim @page_name.to_sym,
          :layout => layout,
          :layout_options => {:views => settings.layouts_dir}
      else
        show_404
      end
    end

  end
end
