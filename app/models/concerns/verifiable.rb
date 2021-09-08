module Verifiable
  extend ActiveSupport::Concern

  class_methods do
    def check_integer(string)
      string.scan(/\D/).empty?
    end
  end
end
