require 'recursive-open-struct'

module Viberroo
  class Response
    def self.init(params)
      RecursiveOpenStruct.new params
    end
  end
end
