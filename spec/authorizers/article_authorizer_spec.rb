require 'rails_helper'

RSpec.describe ArticleAuthorizer do
  let(:user) { create :user }
  let(:editor) { create :user, role: :editor }
  let(:admin) { create :user, role: :admin }
  let(:article) { create :article, user: editor }
  let(:article_another_user) { create :article }
  let(:published_article) { create :article, user: editor, status: :published }

  describe 'class' do
    context 'when user have not role' do
      it 'does not let user create' do
        expect(ArticleAuthorizer).to_not be_creatable_by(user)
      end
    end

    context 'when user has role :editor' do
      it 'lets editor create' do
        expect(ArticleAuthorizer).to be_creatable_by(editor)
      end
    end

    context 'when user has role :admin' do
      it 'lets admin create' do
        expect(ArticleAuthorizer).to be_creatable_by(admin)
      end
    end
  end

  describe 'instances' do
    context 'when user have not role' do
      it 'does not let user read draft articles' do
        expect(article.authorizer).to_not be_readable_by(user)
      end

      it 'lets user read published articles' do
        expect(published_article.authorizer).to be_readable_by(user)
      end

      it 'does not let user update' do
        expect(article.authorizer).to_not be_updatable_by(user)
      end

      it 'does not let user delete' do
        expect(article.authorizer).to_not be_deletable_by(user)
      end
    end

    context 'when user has role :editor' do
      context 'is owner articles' do
        it 'lets editor read draft articles' do
          expect(article.authorizer).to be_readable_by(editor)
        end

        it 'lets editor update' do
          expect(article.authorizer).to be_updatable_by(editor)
        end

        it 'lets editor delete' do
          expect(article.authorizer).to be_deletable_by(editor)
        end
      end

      context 'is not owner articles' do
        it 'does not let editor read draft articles' do
          expect(article_another_user.authorizer).to_not be_readable_by(editor)
        end

        it 'does not let editor update' do
          expect(article_another_user.authorizer).to_not be_updatable_by(editor)
        end

        it 'does not let editor delete' do
          expect(article_another_user.authorizer).to_not be_deletable_by(editor)
        end
      end
    end

    context 'when user has role :admin' do
      it 'lets admin read draft articles' do
        expect(article_another_user.authorizer).to be_readable_by(admin)
      end

      it 'lets admin update' do
        expect(article_another_user.authorizer).to be_updatable_by(admin)
      end

      it 'lets admin delete' do
        expect(article_another_user.authorizer).to be_deletable_by(admin)
      end
    end
  end
end
