class Calendar

  def initialize(calendar)
    @cal = calendar   
  end

  def available?(yyyy, mm, dd)
    split_cal = split_cal(yyyy, mm, dd)
    return false if split_cal[mm][dd - 1] == '1'
    true
  end
  
  def book(yyyy, mm, dd)
    @cal = set(yyyy, mm, dd, true)
  end

  def unbook(yyyy, mm, dd)
    @cal = set(yyyy, mm, dd, false)
  end

  private

  def set(yyyy, mm, dd, book)
    split_cal = split_cal(yyyy, mm ,dd)
    split_cal[mm][dd - 1] = book ? '1' : '0'
    split_cal.join("-") 
  end  

  def split_cal(yyyy, mm, dd)
    year = @cal.split("-")[0].to_i
    raise "Date year [#{yyyy}] does not match calendar year [#{year}]" unless year == yyyy
    @cal.split("-")
  end
end
