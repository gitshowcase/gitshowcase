module SocialsHelper
  def self.grouped
    groups = {}

    User::SOCIALS.each do |social, properties|
      groups[properties[:type]] ||= {}
      groups[properties[:type]][social] = properties
    end

    groups
  end
end
