# Other authorizers should subclass this one
class ApplicationAuthorizer < Authority::Authorizer
  # Any class method from Authority::Authorizer that isn't overridden
  # will call its authorizer's default method.
  #
  # @param [Symbol] adjective; example: `:creatable`
  # @param [Object] user - whatever represents the current user in your app
  # @return [Boolean]
  def self.default(adjective, user)
    # 'Whitelist' strategy for security: anything not explicitly allowed is
    # considered forbidden.
    user.has_role? :admin
  end
end
# роли:
# 1. Нет роли - Просто зарегистрированный пользователь. 
# Может добавлять предложения по фудшерингу.
# 2. Редактор (editor) - Получает права на создание/редактирование/удаление 
# статей на сайте
# 3. Кафе (cafe) - Имеет отдельный профиль регистрации, 
# добавляет непубличные предложения по фудшерингу. 
# Забрать в конце дня в определенное время из кафе остатки еды. 
# Данные непубличные предложения доступны только для волонтёров.
# 4. Волонтёр (volunteer) - Доступен просмотр предложений по фудшерингу от кафе
# 5. Админ (admin) - Имеет права на всё
