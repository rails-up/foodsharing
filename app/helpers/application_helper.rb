module ApplicationHelper
  def belongs?(entity, entity_name)
    entity_name.include?(params["#{entity}"])
  end
end
