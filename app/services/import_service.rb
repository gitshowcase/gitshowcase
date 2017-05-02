class ImportService < ApplicationService
  def import
    puts "#import not implemented for #{self.class.name}"
  end

  def export
    puts "#export method not implemented for #{self.class.name}"
  end

  protected

  def export_yaml(filename, data)
    File.open(path(filename), 'w') do |f|
      map = data.map { |model| model.attributes.except('id') }
      f.write(map.to_yaml)
    end
  end

  def path(filename)
    Rails.root.join('db', 'data', "#{filename}.yaml")
  end
end
