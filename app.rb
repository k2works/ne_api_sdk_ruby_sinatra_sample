require "sinatra/base"
require "sinatra/reloader"

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

      set :layouts_dir, 'views/_layouts'
      set :partials_dir, 'views/_partials'
    end

    helpers do
      def show_404
        status 404
        @page_name = '404'
        @page_title = '404'
        erb :'404', :layout => :with_sidebar,
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
      @page_title = 'Home page'
      erb :index,
        :layout => :full_width,
        :layout_options => {:views => settings.layouts_dir}
    end


    # Routes for pages that have unique things...

    get '/special/' do
      @page_name = 'special'
      @page_title = 'A special page'
      @time = Time.now
      erb :special,
		  :layout => :with_sidebar,
          :layout_options => {:views => settings.layouts_dir}
    end

	get '/login/' do
      @page_name = 'login'
      @page_title = 'A login page'
      erb :login,
        :layout_options => {:views => settings.layouts_dir}
    end

	get '/form/' do
      @page_name = 'fome'
      @page_title = 'Form page'
      erb :form,
        :layout => :full_width,
        :layout_options => {:views => settings.layouts_dir}
    end

	get '/table/' do
      @page_name = 'table'
      @page_title = 'Table page'
      erb :table,
        :layout => :full_width,
        :layout_options => {:views => settings.layouts_dir}
    end

	get '/javascript/' do
      @page_name = 'JavaScript'
      @page_title = 'JavaScript page'
      erb :javascript,
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
        erb @page_name.to_sym,
          :layout => layout,
          :layout_options => {:views => settings.layouts_dir}
      else
        show_404
      end
    end

  end
end
