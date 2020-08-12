require_relative 'time_return'

class App

  def call(env)
    @env = env

    if valid_path?
      timereturn = TimeReturn.new(request.params['format'])
      if timereturn.has_invalid?
        rack_response(400,"Unknown time format [#{timereturn.invalid}]")
      else
        rack_response(200, timereturn.format)
      end
    else
      rack_response(404, 'Page not found')
    end
  end

  private

  def rack_response(status, body)
    Rack::Response.new(status, {"Content-Type" => "text/html"}, [body]).finish
  end

  def request
    @request ||= Rack::Request.new(@env)
  end

  def valid_path?
    request.path == '/time'
  end
end
