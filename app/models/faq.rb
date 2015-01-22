class Faq

  attr_accessor :question, :answer, :slug

  def generate_slug
    question.downcase.gsub('?', '').gsub(' ', '-')
  end

end
