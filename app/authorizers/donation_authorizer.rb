class DonationAuthorizer < ApplicationAuthorizer
  def self.specializable_by?(user)
    user.has_role?(:cafe) || user.has_role?(:volunteer) || user.has_role?(:admin)
    # return (user.has_role?(:cafe) || user.has_role?(:admin))
    #   if [:new, :create, :edit, :update].include? key[:action_name].to_sym
    # false
  end

  def readable_by?(user)
    return (user.has_role?(:cafe) || user.has_role?(:volunteer) || user.has_role?(:admin)) if resource.special?
    true
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
