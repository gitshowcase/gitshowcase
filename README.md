# Git Showcase

Awesome Portfolio from your GitHub

### System Requirements

- Ruby `2.2.2+`

### Database setup

- Create
    `rails db:create`
- Migrate
    `rails db:migrate`
- Seed
    `rails db:seed`
   
# Generating Favicons

1. Update the file `app/assets/images/logo.png`
2. Ru`rails generate favicon`
3. Move the file `app/views/application/_favicon.html.erb` to `app/views/layouts/partials/head/_favicon.html.erb`
4. Delete the file `app/assets/images/favicon/manifest.json.erb`
   
### Running Tests

`rails test`
