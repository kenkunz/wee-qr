require 'qrencoder'

class QRGenerator
  def call(env)
    qr_data = env['PATH_INFO'][1..-1]
    qr_code = QREncoder.encode(qr_data)
    qr_png  = qr_code.png.to_blob

    [ 200, {'Content-Type'=>'image/png'}, [ qr_png ] ]
  end
end
