class Url < ApplicationRecord
  validates :long_url, presence: true
  before_validation :check_long_url
  validates :long_url, uniqueness: true, format: {with: /(\w+\.)+\w{2,}/, message: "Is not a valid url"}

  def repeat
    random_short = "#{SecureRandom.hex(4)}"
    @unique_short = random_short
    if Url.where(short_url: @unique_short).count > 0
      @unique_short = ""
    end
  end

  def shorten
    if self.short_url.nil?
      while @unique_short == nil || @unique_short == ""
        repeat
        if @unique_short != ""
          self.short_url = @unique_short
        end
      end
    end
  end

  def check_long_url
    if (!self.long_url.include? "https://") || (!self.long_url.include? "http://")
      if (!self.long_url.include? "http://")
        if !self.long_url.include? "www."
          if self.long_url =~ /(\w+\.)+\w{2,}/
            self.long_url = "https://www.#{self.long_url}"
          end
        else
          if !(self.long_url.include? "https://")
            string = self.long_url.partition("www.")
            if string[2] =~ /(\w+\.)+\w{2,}/
              self.long_url = "https://#{self.long_url}"
            else
              self.long_url = string[2]
            end
          else
            string = self.long_url.partition("www.")
            if string[2] =~ /(\w+\.)+\w{2,}/
              self.long_url = "#{self.long_url}"
            else
              self.long_url = string[2]
            end
          end
        end
      else
        string = self.long_url.partition("http://")
        if string[2] =~ /(\w+\.)+\w{2,}/
          self.long_url
        else
          self.long_url = string[2]
        end
      end
    else
      if self.long_url.include? "https://"
        string = self.long_url.partition("https://")
        if string[2].include? "www."
          string1 = string[2].partition("www.")
          if (string1[2] =~ /(\w+\.)+\w{2,}/) == nil
            self.long_url = string1[2]
          end
        end
      end
    end
  end
end
