class ImportService < ApplicationService
  def initialize(filename = nil)
    filename ||= self.class.filename
    @filename = filename
  end

  def path
    raise "Undefine filename for #{self.class.name}" unless @filename.present?
    Rails.root.join('db', 'data', "#{@filename}.yaml")
  end

  def import
    raise "#import not implemented for #{self.class.name}"
  end

  def export
    raise "#export method not implemented for #{self.class.name}"
  end

  protected

  def self.filename
  end

  def yaml_records
    YAML.load_file(path)
  end

  def export_yaml(data)
    File.open(path, 'w') do |f|
      map = data.map { |model| model.attributes.except('id') }
      f.write(map.to_yaml)
    end
  end
end
