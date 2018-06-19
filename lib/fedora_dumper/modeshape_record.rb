module FedoraDumper
  class ModeshapeRecord < ActiveRecord::Base
    self.table = 'modeshape_repository'

    def to_h
      BSON::Document.from_bson(BSON::ByteBuffer.new(content_bytes)).to_h
    end

    def to_json
      to_h.to_json
    end

    def content_bytes
      content[2..-1].to_byte_string
    end
  end
end
