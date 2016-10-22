FactoryGirl.define do
  sequence :article_title do |n|
    "Article title test #{n}"
  end

  sequence :article_content do |n|
    "Article content test #{n}"
  end

  factory :article do
    title :article_title
    content :article_content
  end

  factory :invalid_article, class: 'Article' do
    title nil
    content nil
  end
end
