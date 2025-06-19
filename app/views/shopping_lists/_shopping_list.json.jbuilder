json.extract! shopping_list, :id, :title, :budget, :shopped_on, :created_at, :updated_at
json.url shopping_list_url(shopping_list, format: :json)
