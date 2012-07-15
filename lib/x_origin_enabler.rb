class XOriginEnabler
  ORIGIN_HEADER = "Access-Control-Allow-Origin"
 
  def initialize(app, accepted_domain="*")
    @app = app
    @accepted_domain = accepted_domain
  end
 
  def call(env)
    status, header, body = @app.call(env)
    header[ORIGIN_HEADER] = @accepted_domain
    [status, header, body]
  end
end