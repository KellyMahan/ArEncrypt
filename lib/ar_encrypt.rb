require 'digest/sha1'
module ArEncrypt
  def self.encrypt(string)
    Digest::SHA1.hexdigest(string).to_s
  end
end
require 'ar_encrypt/active_record'