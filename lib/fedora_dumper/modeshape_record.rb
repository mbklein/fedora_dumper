module FedoraDumper
  class ModeshapeRecord < ActiveRecord::Base
    self.table_name = 'modeshape_repository'

    def to_h
      BSON::Document.from_bson(BSON::ByteBuffer.new(content)).to_h
    end

    def to_json
      to_h.to_json
    end
  end
end
