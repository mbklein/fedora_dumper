require 'recursive-open-struct'

module FedoraDumper
  class ModeshapeRecord < ActiveRecord::Base
    self.table_name = 'modeshape_repository'

    def key
      to_struct.content.key
    end

    def name
      return '' if parent.nil?
      parent.to_struct.content.children.find { |c| c.key == key }.name
    end

    def fedora_id
      return '' if parent.nil?
      [parent.fedora_id, name].join('/')
    end

    def to_h
      BSON::Document.from_bson(BSON::ByteBuffer.new(content)).to_h
    end

    def to_json
      to_h.to_json
    end

    def to_struct
      RecursiveOpenStruct.new(to_h)
    end

    def parent
      parent_id = to_struct.content&.parent
      return nil if parent.nil?
      self.class.find(parent_id)
    end
  end
end
