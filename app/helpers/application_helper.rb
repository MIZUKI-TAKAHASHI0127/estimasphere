module ApplicationHelper
  def number_with_delimiter(number)
    number.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, "\\1,")
  end
end