class DonationAuthorizer < ApplicationAuthorizer
  def self.specializable_by?(user, key)
    return (user.has_role?(:cafe) || user.has_role?(:admin)) if [:new, :create, :edit, :update].include? key.to_sym
    return (user.has_role?(:cafe) || user.has_role?(:volunteer) || user.has_role?(:admin)) if :index == key.to_sym
    false
  end

  def creatable_by?(user)
    return (user.has_role?(:cafe) || user.has_role?(:admin)) if resource.special?
    true
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
    # return (user.has_role?(:cafe) || user.has_role?(:admin)) if resource.special?
    # resource.user == user || user.has_role?(:admin)

    return resource.user == user || user.has_role?(:admin) unless resource.special?
    resource.user == user && user.has_role?(:cafe) || user.has_role?(:admin)
  end
end
