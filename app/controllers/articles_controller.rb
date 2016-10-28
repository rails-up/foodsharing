class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = Article.published
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
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
    params.require(:article).permit(:title, :content)
  end

  def load_article
    @article = Article.find(params[:id])
  end
end
