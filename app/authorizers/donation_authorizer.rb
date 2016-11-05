class DonationAuthorizer < ApplicationAuthorizer
  # def self.creatable_by?(user)
  #   user.manager?
  # end

  # Instance method:
  def editable_by?(user)
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
