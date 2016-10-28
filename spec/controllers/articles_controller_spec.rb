require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:article) { create(:article) }
  let(:articles) { create_list(:article, 3) }
  let(:user) { create(:user) }
  before do
    sign_in user
  end

  describe 'GET #index' do
    before { get :index }

    it 'populates an array of all published articles' do
      articles.each { |article| article.published! }
      expect(assigns(:articles)).to match_array(articles)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: article } }

    it 'assigns the requested article to @article' do
      expect(assigns(:article)).to eq article
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Article to @article' do
      expect(assigns(:article)).to be_a_new(Article)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: article } }

    it 'assigns the requested article to @article' do
      expect(assigns(:article)).to eq article
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    let(:subject) { post :create, params: { article: attributes_for(:article) } }
    let(:invalid_subject) { post :create, params: { article: attributes_for(:invalid_article) } }

    context 'with valid attributes' do
      it 'saves new article in the database' do
        expect { subject }.to change(Article, :count).by(1)
      end

      it 'redirect to show view' do
        subject
        expect(response).to redirect_to article_path(assigns(:article))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the article' do
        expect { invalid_subject }.to_not change(Article, :count)
      end

      it 're-renders new view' do
        invalid_subject
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATH #update' do
    let(:update_article) do
      patch :update,
            params: {
              id: article,
              article: attributes_for(:article)
            }
    end
    let(:update_article_attr) do
      patch :update,
            params: {
              id: article,
              article: {
                title: 'edited title',
                content: 'edited content'
              }
            }
    end

    context 'with valid attributes' do
      it 'assigns the requested article to @article' do
        update_article
        expect(assigns(:article)).to eq article
      end

      it 'change article attributes' do
        update_article_attr
        article.reload
        expect(article.title).to eq 'edited title'
        expect(article.content).to eq 'edited content'
      end

      it 'render to the updated article' do
        update_article
        expect(response).to redirect_to article
      end
    end

    context 'with invalid attributes' do
      before do
        patch :update,
              params: {
                id: article,
                article: attributes_for(:invalid_article)
              }
      end

      it 'not change article attributes' do
        article.reload
        expect(article.title).to_not eq nil
        expect(article.content).to_not eq nil
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:destroy_article) do
      delete :destroy, params: { id: article }
    end
    before { article }

    it 'delete article' do
      expect { destroy_article }.to change(Article, :count).by(-1)
    end

    it 'redirect to index view' do
      destroy_article
      expect(response).to redirect_to articles_path
    end
  end
end
