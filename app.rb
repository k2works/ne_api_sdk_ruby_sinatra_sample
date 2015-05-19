require "sinatra/base"
require "sinatra/reloader"
require "slim"
require 'dotenv'
require 'redis'

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
      else
        AP_SERVER_HOST   = 'https://hcoss.healthy-com.com'
        AP_SERVER_PORT   = '80'
        AP_NE_SERVER_HOST = 'https://ne64.next-engine.com'
        AP_NE_SERVER_PORT = '80'
      end

      if AP_SERVER_PORT == '80'
        set :ap_server, AP_SERVER_HOST
      else
        set :ap_server, AP_SERVER_HOST + ':' +AP_SERVER_PORT
      end

      if AP_NE_SERVER_PORT == '80'
        set :ap_ne_server, AP_NE_SERVER_HOST
      else
        set :ap_ne_server, AP_NE_SERVER_HOST + ':' +AP_NE_SERVER_PORT
      end


      set :layouts_dir, 'views/_layouts'
      set :partials_dir, 'views/_partials'

      Dotenv.load

      REDIS = Redis.new(
          host: ENV["REDIS_HOST"],
          port: ENV["REDIS_PORT"]
      )
    end

    helpers do
      def show_404
        status 404
        @page_name = '404'
        @page_title = '404'
        slim :'404', :layout => :with_sidebar,
                    :layout_options => {:views => settings.layouts_dir}
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

    get '/delivery_method/' do
      @page_name = 'delivery_method'
      @page_title = '便種振り分け'
      slim :delivery_method,
           :layout => :full_width,
           :layout_options => {:views => settings.layouts_dir}
    end

    get '/picking_list/' do
      @page_name = 'picking_list'
      @page_title = 'ピッキングリスト印刷'
      slim :delivery_method,
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
