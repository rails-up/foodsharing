module Admin
  class ArticlesController < AdminController
    def index
      @articles = Article.all
    end
  end
end
