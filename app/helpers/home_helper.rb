module HomeHelper
  
  def show_lab_flow_department(partial)
     contents = render :partial=>partial
     page << "$('#labDepartment').html(#{contents.to_json})"
  end
  
  def display_page_error(message)
     page << "$('#errorMessage').html(#{message.to_json})"
     page << "$('#pageError').show('blind', {direction: 'vertical'}, 500)"
  end
  
  def clear_page_error
    page << "$('#errorMessage').html('')"
    page << "$('#pageError').hide()"
  end
  
end
