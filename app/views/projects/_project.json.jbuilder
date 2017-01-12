json.extract! project, :id, :title, :url, :repository, :image, :description, :user_id, :language, :created_at, :updated_at
json.url project_url(project, format: :json)