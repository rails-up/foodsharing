class ArticleAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    user.has_role?(:editor) || user.has_role?(:admin)
  end

  def readable_by?(user)
    resource.published? || allow?(user)
  end

  def updatable_by?(user)
    allow?(user)
  end

  def deletable_by?(user)
    allow?(user)
  end

  private

  def allow?(user)
    (resource.user == user && user.has_role?(:editor)) || user.has_role?(:admin)
  end
end
