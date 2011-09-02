require 'openssl'
require 'erb'
require 'base64'

class ActionController::Base
  def self.check_versapay_signatures(key, *args)
    before_filter lambda { |controller| check_versapay_signature(key, controller)}, *args
  end

  def self.check_versapay_signature(key, controller)
    # Save the signature first
    signature = controller.request.parameters["signature"]

    # Only want the parameters passed from VP, and no sig
    params = controller.request.parameters.dup
    ["action", "controller", "signature"].each { |k| params.delete(k) }

    url = controller.request.url.gsub /\?.*/, ""
    check = Versapay::WebhookSignature.hmac(controller.request.method, url, key, params)
    unless logger.nil?  then
      logger.warn "============="
      logger.warn controller.request.method
      logger.warn url
      logger.warn key
      logger.warn params.inspect
    end

    if check == signature
      true
    else
      raise Versapay::InvalidWebhookSignature
    end
  end
end

module Versapay
  class WebhookSignature
    include ERB::Util
    
    attr_reader :signature
    alias :to_s :signature
    
    def self.hmac(*args)
      new(*args).to_s
    end
    
    # @param [Symbol, String] method The HTTP method of the request (:get, :post)
    # @param [String] url The URL that the request is going to
    # @param [String] key The private key to be used for signing
    # @param [Hash] attributes The hash of attributes that will be sent in the request 
    def initialize(method, url, key, attributes)
      @method     = method
      @url        = url
      @key        = key
      @attributes = attributes
      @signature  = generate_signature
    end
    
    private
    
    # HMAC of the request in the following format.
    # Attributes are sorted by byte size.
    # Finally, it is Base64'd and url encoded.
    #
    #  POST\n
    #  https://secure.versapay.com/transactions\n
    #  account_typebusinesuser[first_name]Johnuser[last_name]doe
    #
    def generate_signature
      hmac = OpenSSL::HMAC.digest(OpenSSL::Digest::SHA256.new, @key, hmac_string)
      url_encode Base64.encode64(hmac)
    end
    
    def hmac_string
      str =  "#{@method.to_s.upcase}\n"
      str << "#{@url}\n"
      str << sorted_attribute_string
    end
      
    def sorted_attribute_string
      return "" if @attributes.empty?
      nested_keys(@attributes).join
    end
    
    # Nested keys flattens nested hashes like :to_query ie. transaction[type]
    # This is useful to support request signing when, for example, requests are sent as XML 
    def nested_keys(hash, namespace=nil, result=[])
      hash.stringify_keys.each do |key,value|
        current_key = namespace ? "#{namespace}[#{key}]" : key
        if value.is_a?(Hash)
          nested_keys(value, current_key, result)
        else
          result << [current_key, value]
        end
      end
      result.sort_by {|k,v| k}
    end
  end
end
