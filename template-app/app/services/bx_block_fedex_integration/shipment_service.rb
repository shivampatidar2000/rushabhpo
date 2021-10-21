module BxBlockFedexIntegration
  class ShipmentService
    require 'oauth2'
    require 'json'

    OAUTH_SITE_URL = "https://auth-dev.525k.io".freeze
    BASE_URL = "https://api-dev.scdev.io/api".freeze
    CLIENT_ID = ENV['_525K_CLIENT_ID'].freeze
    CLIENT_SECRET = ENV['_525K_CLIENT_SECRET'].freeze
    API_KEY = ENV['_525K_API_KEY'].freeze
    # CLIENT_ID = 'eoranfipd3srt30dodu12mjiq'.freeze
    # CLIENT_SECRET = 'pjrvsoolgut284rqkf7ori8c2m0jdocibvi9ta3lqd9cdkarpbh'.freeze
    # API_KEY = 'Rtjh3tWpoFaDNyFOIygHm4Qz8In7neO8r31r7795'.freeze


    attr_reader :token

    def initialize
      client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, :site => OAUTH_SITE_URL)
      client.options[:authorize_url] = "/oauth2/authorize"
      client.options[:token_url] = "/oauth2/token"

      @token = client.client_credentials.get_token
    end

    def create(shipment_params)
      create_shipment = CreateShipment.new(shipment_params)

      payload = trasformed_payload(create_shipment)
      response = token.post("#{BASE_URL}/shipments", body: payload.to_json, headers: headers)
      result = JSON.parse response.body

      if result['shipments'].present?
        result = result['shipments'][0]
        save_create_shipment(create_shipment, result)
      end

      result
    end

    def get(waybill)
      response = token.get("#{BASE_URL}/shipments/#{waybill}", headers: headers)
      JSON.parse response.body
    end

    private

    def headers
      {"Content-Type":"application/json", "x-api-key": API_KEY}
    end

    def trasformed_payload(create_shipment)
      serialized_data = CreateShipmentSerializer.new(create_shipment).serializable_hash
      data = serialized_data[:data][:attributes]
      data.deep_transform_keys { |key| key.to_s.camelcase(:lower) }
    end

    def save_create_shipment(create_shipment, result)
      begin
        create_shipment.waybill = result['waybill']
        create_shipment.save!
      rescue ActiveRecord::RecordInvalid => e
        puts e.message
      end
    end
  end
end
