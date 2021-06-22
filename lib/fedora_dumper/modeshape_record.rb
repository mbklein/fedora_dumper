require 'recursive-open-struct'

module FedoraDumper
  class ModeshapeRecord < ActiveRecord::Base
    self.table_name = 'modeshape_repository'

    def key
      to_struct.content.key
    end

    def name
      return '' if parent.nil?
      parent.to_struct.content.children.find { |c| c['key'] == key }['name']
    end

    def fedora_id
      return nil if key.nil? || key.match?(/jcr:/) || name.blank?
      return '/rest' if parent.nil?
      [parent.fedora_id, name].join('/')
    end

    def to_bson
      BSON::Document.from_bson(BSON::ByteBuffer.new(content))
    end

    def to_h
      to_bson.to_h
    end

    def to_json
      to_h.to_json
    end

    def to_struct
      RecursiveOpenStruct.new(to_h)
    end

    def parent_id
      to_struct.content&.parent
    end

    def parent
      return nil if parent_id.nil?
      self.class.find(parent_id)
    end

    def child_ids
      to_struct.content&.children&.map { |child| child['key'] } || []
    end

    def children
      child_ids.map do |id| 
        self.class.find(id) rescue nil
      end.compact
    end

    def traverse(&block)
      children.map { |child| child.traverse(&block) }
      yield self
    end
  end
end
