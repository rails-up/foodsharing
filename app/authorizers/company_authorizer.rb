class CompanyAuthorizer < ApplicationAuthorizer
  def creatable_by?(user)
    allow?(user)
  end

  def updatable_by?(user)
    allow?(user)
  end

  def deletable_by?(user)
    allow?(user)
  end

  private

  def allow?(user)
    resource.user == user || user.has_role?(:admin)
  end
end
