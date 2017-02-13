module GithubProject
  extend ActiveSupport::Concern

  class_methods do
    def sync_by_user(user)
      result = []

      repos = user.client.repositories
      repos.each do |repository_data|
        params = {user_id: user.id}

        if repository_data.full_name.present?
          params[:repository] = repository_data.full_name
        elsif repository_data.homepage.present?
          params[:homepage] = repository_data.homepage
        else
          next
        end

        project = where(params).first

        unless project
          project = self.new(user_id: user.id, repository: repository_data.full_name)
          project.sync repository_data
          result.push project
        end
      end

      result
    end
  end

  def sync_repository(data = nil)
    return false unless repository.present?

    data ||= user.client.repository(self.repository)

    self.title = data.name.titleize
    self.homepage = data.homepage
    self.repository = data.full_name
    self.description = data.description
    self.language = data.language
  end
end
