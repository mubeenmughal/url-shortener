class Url < ApplicationRecord
    validates :original_url, presence: true, format: URI::regexp(%w[http https])
    validates :short_url, presence: true, uniqueness: true

    before_validation :generate_short_url, on: :create, unless: -> { short_url.present? }
    scope :active, -> { where('expires_at IS NULL OR expires_at > ?', Time.current) }

    private
  
    def generate_short_url
      self.short_url ||= SecureRandom.alphanumeric(6)
    end
  end
  