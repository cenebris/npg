class TitleBracketsValidator < ActiveModel::Validator
  attr_accessor :errors

  def initialize(title)
    @title = title
    @brackets = get_brackets_from_title
    self.errors = []
  end

  def valid?
    check_empty_brackets_in_title
    validate_brackets
    errors.empty?
  end

  def brackets_hash
    {'(' => ')',
     '[' => ']',
     '{' => '}'
    }
  end

  private

  def validate_brackets
    loop do
      break if no_more_brackets? || errors.any?
      errors << ('Odd number of brackets') if odd_number_of_brackets?
      find_pair_of_brackets
    end
  end

  def find_pair_of_brackets
    bracket = @brackets.slice!(0)
    if brackets_hash.keys.include?(bracket) && @brackets.include?(brackets_hash[bracket])
      @brackets.sub!(brackets_hash[bracket],'')
    end
  end

  def check_empty_brackets_in_title
    errors << ('Empty brackets') if @title.scan(/\(\s*\)/).any?
    errors << ('Empty brackets') if @title.scan(/\{\s*\}/).any?
    errors << ('Empty brackets') if @title.scan(/\[\s*\]/).any?
  end

  def get_brackets_from_title
    @title.delete('^{}()[]')
  end

  def odd_number_of_brackets?
    @brackets.size.odd?
  end

  def no_more_brackets?
    @brackets.empty?
  end
end