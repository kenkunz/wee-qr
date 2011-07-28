require 'qrencoder'

class QRGenerator
  def call(env)
    path = env['PATH_INFO']
    if path.length > 1
      qr_data = Rack::Utils.unescape(path[1..-1])
      qr_code = QREncoder.encode(qr_data)
      qr_png  = qr_code.png(:pixels_per_module => 5).to_blob
    end
    [ 200, {'Content-Type'=>'image/png'}, [ qr_png || '' ] ]
  end
end
