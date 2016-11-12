class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_article, only: [:show, :edit, :update, :destroy]
  before_action :authorize_article, only: [:show, :edit, :update, :destroy]
  authorize_actions_for Article, only: [:new, :create]

  def index
    my_articles = params[:my_articles]
    return @articles = Article.published unless current_user.present? && Article.statuses.key?(my_articles)
    return @articles = Article.where(status: my_articles) if current_user.has_role? :admin
    @articles = Article.where(user_id: current_user.id, status: my_articles)
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    if @article.save
      redirect_to @article
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :status)
  end

  def load_article
    @article = Article.find(params[:id])
  end

  def authorize_article
    authorize_action_for @article
  end
end
