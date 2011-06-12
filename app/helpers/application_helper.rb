module ApplicationHelper

  def shorten_string(value, length)
    return value if value.blank?
    if value.length > length
      return value[0..length-4] + "..."
    end
    value
  end
  
  def format_long_date(date)  
    return date if date.blank?
    date.strftime('%m/%d/%Y %I:%M %p')
  end
  
  def clear
    "<div style='clear:both'></div>".html_safe
  end
  
  def update_current_lab_center
    contents = render :partial=>'shared/lab_center'
    page << "$('#labCenter').html(#{contents.to_json})"
  end
  
  def bottom_border
    "<div style=\"clear:both;border-bottom:1px solid gray\"></div>".html_safe
  end
  
end
