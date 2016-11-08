module WelcomeHelper
  def show_video
    if Rails.env.production?
      "{videoURL: 'https://www.youtube.com/watch?v=95SNbn340TE',containment:'.video-section', quality:'large', autoPlay:true, mute:true, opacity:1}"
    end
  end
end
