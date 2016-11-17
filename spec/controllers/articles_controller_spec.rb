require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:user) { create(:user) }
  let(:editor) { create(:user, role: :editor) }
  let(:admin) { create(:user, role: :admin) }
  let(:published_article) { create(:article, user: editor, status: :published) }
  let(:draft_article) { create(:article, user: editor, status: :draft) }
  let(:article_another_user) { create(:article, status: :draft) }

  describe 'GET #index' do
    let(:published_articles) { create_list(:article, 3, user: editor, status: :published) }
    let(:draft_articles) { create_list(:article, 3, user: editor, status: :draft) }
    let(:articles_another_user) { create_list(:article, 3, status: :draft) }

    context 'when user unauthenticated' do
      it 'populates an array of all published articles' do
        published_articles
        get :index
        expect(assigns(:articles)).to match_array(published_articles)
      end

      it 'renders index view' do
        published_articles
        get :index
        expect(response).to render_template :index
      end

      it 'no populates an array of all draft articles' do
        draft_articles
        get :index, params: { my_articles: :draft }
        expect(assigns(:articles)).to_not match_array(draft_articles)
      end
    end

    context 'when user have not role' do
      it 'no populates an array of all draft articles' do
        sign_in user
        draft_articles
        get :index, params: { my_articles: :draft }
        expect(assigns(:articles)).to_not match_array(draft_articles)
      end
    end

    context 'when user has role :editor' do
      before { sign_in editor }
      context 'is owner articles' do
        it 'populates an array of all draft articles' do
          draft_articles
          get :index, params: { my_articles: :draft }
          expect(assigns(:articles)).to match_array(draft_articles)
        end
      end

      context 'is not owner articles' do
        it 'no populates an array of all draft articles' do
          articles_another_user
          get :index, params: { my_articles: :draft }
          expect(assigns(:articles)).to_not match_array(articles_another_user)
        end
      end
    end

    context 'when user has role :admin' do
      it 'populates an array of all draft articles' do
        sign_in admin
        articles_another_user
        get :index, params: { my_articles: :draft }
        expect(assigns(:articles)).to match_array(articles_another_user)
      end
    end
  end

  describe 'GET #show' do
    let(:subject_draft) { get :show, params: { id: draft_article } }
    let(:subject_published) { get :show, params: { id: published_article } }
    let(:subject_another_user) { get :show, params: { id: article_another_user } }

    context 'when user unauthenticated' do
      it 'assigns the requested article to @article' do
        subject_published
        expect(assigns(:article)).to eq published_article
      end

      it 'renders show view if published article' do
        subject_published
        expect(response).to render_template :show
      end

      it 'redirect to root if draft article' do
        subject_draft
        expect(response).to redirect_to root_path
      end
    end

    context 'when user have not role' do
      it 'redirect to root if draft article' do
        sign_in user
        subject_draft
        expect(response).to redirect_to root_path
      end
    end

    context 'when user has role :editor' do
      before { sign_in editor }

      context 'is owner article' do
        it 'renders show view if draft article' do
          subject_draft
          expect(response).to render_template :show
        end
      end

      context 'is not owner articles' do
        it 'redirect to root if draft article' do
          subject_another_user
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'when user has role :admin' do
      it 'renders show view if draft article' do
        sign_in admin
        subject_another_user
        expect(response).to render_template :show
      end
    end
  end

  describe 'GET #new' do
    context 'when user unauthenticated' do
      before { get :new }

      it 'no assigns a new Article to @article' do
        expect(assigns(:article)).to_not be_a_new(Article)
      end

      it 'redirect to new user session' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user have not role' do
      before do
        sign_in user
        get :new
      end

      it 'no assigns a new Article to @article' do
        expect(assigns(:article)).to_not be_a_new(Article)
      end

      it 'redirect to root' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when user has role :editor' do
      before do
        sign_in editor
        get :new
      end

      it 'assigns a new Article to @article' do
        expect(assigns(:article)).to be_a_new(Article)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    context 'when user has role :admin' do
      before do
        sign_in admin
        get :new
      end

      it 'assigns a new Article to @article' do
        expect(assigns(:article)).to be_a_new(Article)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #edit' do
    context 'when user unauthenticated' do
      before { get :edit, params: { id: draft_article } }

      it 'no assigns the requested article to @article' do
        expect(assigns(:article)).to_not eq draft_article
      end

      it 'redirect to new user session' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user have not role' do
      it 'redirect to root' do
        sign_in user
        get :edit, params: { id: draft_article }
        expect(response).to redirect_to root_path
      end
    end

    context 'when user has role :editor' do
      before { sign_in editor }

      context 'is owner article' do
        before { get :edit, params: { id: draft_article } }

        it 'assigns the requested draft article to @article' do
          expect(assigns(:article)).to eq draft_article
        end

        it 'renders edit view' do
          expect(response).to render_template :edit
        end
      end

      context 'is not owner article' do
        it 'redirect to root' do
          get :edit, params: { id: article_another_user }
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'when user has role :admin' do
      it 'renders edit view' do
        sign_in admin
        get :edit, params: { id: article_another_user }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'POST #create' do
    let(:subject_draft) { post :create, params: { article: attributes_for(:article) } }
    let(:subject_invalid) { post :create, params: { article: attributes_for(:invalid_article) } }

    context 'when user unauthenticated' do
      it 'does not save the article' do
        expect { subject_draft }.to_not change(Article, :count)
      end

      it 'redirect to new user session' do
        subject_draft
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user have not role' do
      before { sign_in user }

      it 'does not save the article' do
        expect { subject_draft }.to_not change(Article, :count)
      end

      it 'redirect to root' do
        subject_draft
        expect(response).to redirect_to root_path
      end
    end

    context 'when user has role :editor' do
      before { sign_in editor }

      context 'with valid attributes' do
        it 'saves new article in the database' do
          expect { subject_draft }.to change(Article, :count).by(1)
        end

        it 'redirect to show view' do
          subject_draft
          expect(response).to redirect_to article_path(assigns(:article))
        end
      end

      context 'with invalid attributes' do
        it 'does not save the article' do
          expect { subject_invalid }.to_not change(Article, :count)
        end

        it 're-renders new view' do
          subject_invalid
          expect(response).to render_template :new
        end
      end
    end

    context 'when user has role :admin' do
      before { sign_in admin }

      it 'saves new article in the database' do
        expect { subject_draft }.to change(Article, :count).by(1)
      end

      it 'redirect to show view' do
        subject_draft
        expect(response).to redirect_to article_path(assigns(:article))
      end
    end
  end

  describe 'PATH #update' do
    let(:subject_draft) do
      patch :update,
            params: {
              id: draft_article,
              article: attributes_for(:article)
            }
    end
    let(:subject_updated) do
      patch :update,
            params: {
              id: draft_article,
              article: {
                title: 'edited title',
                content: 'edited content'
              }
            }
    end
    let(:subject_another_user) do
      patch :update,
            params: {
              id: article_another_user,
              article: {
                title: 'edited title',
                content: 'edited content'
              }
            }
    end

    context 'when user unauthenticated' do
      before { subject_updated }

      it 'not change article attributes' do
        draft_article.reload
        expect(draft_article.title).to_not eq 'edited title'
        expect(draft_article.content).to_not eq 'edited content'
      end

      it 'redirect to new user session' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user have not role' do
      before do
        sign_in user
        subject_updated
      end

      it 'not change article attributes' do
        draft_article.reload
        expect(draft_article.title).to_not eq 'edited title'
        expect(draft_article.content).to_not eq 'edited content'
      end

      it 'redirect to root' do
        expect(response).to redirect_to root_path
      end
    end

    context 'when user has role :editor' do
      before { sign_in editor }

      context 'is owner article' do
        context 'with valid attributes' do
          it 'assigns the requested article to @article' do
            subject_draft
            expect(assigns(:article)).to eq draft_article
          end

          it 'change article attributes' do
            subject_updated
            draft_article.reload
            expect(draft_article.title).to eq 'edited title'
            expect(draft_article.content).to eq 'edited content'
          end

          it 'render to the updated article' do
            subject_draft
            expect(response).to redirect_to draft_article
          end
        end

        context 'with invalid attributes' do
          before do
            patch :update,
                  params: {
                    id: draft_article,
                    article: attributes_for(:invalid_article)
                  }
          end

          it 'not change article attributes' do
            draft_article.reload
            expect(draft_article.title).to_not eq nil
            expect(draft_article.content).to_not eq nil
          end

          it 'renders edit view' do
            expect(response).to render_template :edit
          end
        end
      end

      context 'is not owner article' do
        before { subject_another_user }

        it 'not change article attributes' do
          article_another_user.reload
          expect(article_another_user.title).to_not eq 'edited title'
          expect(article_another_user.content).to_not eq 'edited content'
        end

        it 'redirect to root' do
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'when user has role :admin' do
      before do
        sign_in admin
        subject_another_user
      end

      it 'change article attributes' do
        article_another_user.reload
        expect(article_another_user.title).to eq 'edited title'
        expect(article_another_user.content).to eq 'edited content'
      end

      it 'render to the updated article' do
        expect(response).to redirect_to article_another_user
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:subject_draft) { delete :destroy, params: { id: draft_article } }
    let(:subject_another_user) { delete :destroy, params: { id: article_another_user } }

    context 'when user unauthenticated' do
      before { draft_article }
      it 'does not delete article' do
        expect { subject_draft }.to_not change(Article, :count)
      end

      it 'redirect to new user session' do
        subject_draft
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user have not role' do
      before do
        sign_in user
        draft_article
      end

      it 'does not delete article' do
        expect { subject_draft }.to_not change(Article, :count)
      end

      it 'redirect to root' do
        subject_draft
        expect(response).to redirect_to root_path
      end
    end

    context 'when user has role :editor' do
      before { sign_in editor }

      context 'is owner article' do
        before { draft_article }
        it 'delete article' do
          expect { subject_draft }.to change(Article, :count).by(-1)
        end

        it 'redirect to index view' do
          subject_draft
          expect(response).to redirect_to articles_path
        end
      end

      context 'is not owner article' do
        before { article_another_user }

        it 'does not delete article' do
          expect { subject_another_user }.to_not change(Article, :count)
        end

        it 'redirect to root' do
          subject_another_user
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'when user has role :admin' do
      before do
        sign_in admin
        article_another_user
      end

      it 'delete article' do
        expect { subject_another_user }.to change(Article, :count).by(-1)
      end

      it 'redirect to index view' do
        subject_another_user
        expect(response).to redirect_to articles_path
      end
    end
  end
end
