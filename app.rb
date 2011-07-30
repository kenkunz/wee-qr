require 'qrencoder'
require 'time'

class WeeQR
  DEFAULT_MODULE_SIZE = 5

  def call(env)
    @env = env

    if query_string?
      data = qr_code_png
      [ 200, headers(data), [ data ] ]
    else
      [ 404, { 'Content-Type' => 'text/plain' }, [ '404 Not Found' ] ]
    end
  end

  def headers(data)
    {
      'Content-Type' => 'image/png',
      'Content-Length' => data.size.to_s,
      'Date' => Time.now.httpdate
    }
  end

  def path_info
    @env['PATH_INFO']
  end

  def query_string
    @env['QUERY_STRING']
  end

  def query_string?
    !query_string.length.zero?
  end

  def unescaped_query_string
    Rack::Utils.unescape query_string
  end

  def module_size_param
    path_info.split('/')[1].to_i.nonzero?
  end

  def module_size
    module_size_param || DEFAULT_MODULE_SIZE
  end

  def qr_code
    QREncoder.encode(unescaped_query_string)
  end

  def qr_code_png
    qr_code.png(:pixels_per_module => module_size).to_blob
  end

end
