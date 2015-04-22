require File.expand_path '../spec_helper.rb', __FILE__
require File.expand_path '../feature_helper.rb', __FILE__

describe "My Sinatra Application" do
  it "should allow accessing the home page" do
    get '/'
    expect(last_response.status).to eq 200
  end
end