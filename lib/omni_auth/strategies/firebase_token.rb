module OmniAuth
  module Strategies
    class FirebaseToken
      include OmniAuth::Strategy

      attr_reader :verified_token

      args [:project_id]

      def request_phase
        # TODO
      end

      def callback_phase
        id_token = request['id_token']
        decoded_token = decode(id_token)
        verify(decoded_token)
        super
      end

      uid do
        verified_token['sub']
      end
      info do
        {
          'name' => verified_token['name'],
          'email' => verified_token['email'],
          'image' => verified_token['picture']
        }
      end
      extra do
        verified_token
      end


      CLIENT_CERT_URL = 'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'

      def certificates
        @certificates ||= begin
          response = HTTParty.get(CLIENT_CERT_URL)
          JSON.parse(response.body)
        end
      end

      def decode(id_token)
        # see https://github.com/royfall/ruby_firebase_verify/blob/master/lib/ruby_firebase_verify.rb
        jwt_header = JSON.parse(Base64.decode64(id_token.split('.').first)) # 自前でやらなくてもいいはず。。
        raise 'Certificate not found' unless certificates.key?(jwt_header['kid'])
        x509 = OpenSSL::X509::Certificate.new(certificates[jwt_header['kid']])
        JWT.decode(id_token, x509.public_key, true, { algorithm: jwt_header['alg'], verify_iat: false }) # もう少し検証項目増やす
      end

      def verify(decoded_token)
        decoded_token = decoded_token.first if decoded_token.is_a? Array
        raise 'Verify failed' if decoded_token['aud'] != options.project_id
        @verified_token = decoded_token
      end
    end
  end
end
OmniAuth.config.add_camelization 'firebasetoken', 'FirebaseToken'
