module ArticlesHelper
  def count_articles(status)
    current_user.articles.where(status: status).count
  end
end
