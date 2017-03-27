module ArticlesHelper
  def count_articles(status)
    current_user.articles.where(status: status).count
  end

  def link_to_my_articles(status)
    link_to "#{t('.' + status.to_s)} [#{count_articles(status)}]",
            articles_path(my_articles: status),
            class: "btn btn-outline-primary btn-sidebar
                    #{'disabled' if params[:my_articles] == status.to_s}"
  end
end
