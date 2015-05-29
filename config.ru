require './app'
require 'rack'
require 'webrick'
require 'webrick/https'

CERT_PATH = File.expand_path('.ssl', File.dirname(__FILE__))

webrick_options = {
    :Port               => 8088,
    :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
    :DocumentRoot       => "/bin",
    :SSLEnable          => true,
    :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
    :SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "dev.crt.pem")).read),
    :SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(CERT_PATH, "dev.pem")).read),
    :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ]
}

Rack::Handler::WEBrick.run DemoSite::App, webrick_options
