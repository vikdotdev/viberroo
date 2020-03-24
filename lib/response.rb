require 'recursive-open-struct'

module Viberroo
  class Response
    def self.init(params)
      RecursiveOpenStruct.new params.to_h
    end
  end
end
