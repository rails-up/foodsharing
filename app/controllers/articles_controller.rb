class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_article, only: [:show, :edit, :update, :destroy]
  before_action :authorize_article, only: [:edit, :update, :destroy]
  before_action :hide_not_published, only: [:show]

  def index
    case params[:my_articles]
    when 'published'
      current_user ? @articles = Article.where(user_id: current_user.id, status: :published) : not_allowed(articles_path)
    when 'draft'
      current_user ? @articles = Article.where(user_id: current_user.id, status: :draft) : not_allowed(articles_path)
    else
      @articles = Article.where(status: :published)
    end
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

  def hide_not_published

    return nil if @article.published?
    authorize_article
    # return authorize_article if user_signed_in?
    # byebug
    # # authority_forbidden(error)
    # raise Authority::SecurityViolation()
    # # https://github.com/nathanl/authority/blob/master/lib/authority/security_violation.rb
  end

  def not_allowed(path)
    flash[:notice] = t('common.not_allowed')
    redirect_to path
  end

  def authorize_article
    authorize_action_for @article
  end

end
