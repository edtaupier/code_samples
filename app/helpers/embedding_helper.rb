module EmbeddingHelper
  
  def display_embedding
    page.show_lab_flow_department("/embedding/index")
    page.update_current_lab_center
    page << "$('#search_block').focus()"
  end
  
  def display_block_information(block, previous_block=nil)
    content = render :partial=>"/embedding/block_details.html.erb"
    page << "$('#blockDetails').html(#{content.to_json})"
    page << "$('#processingMessage').html('#{block.cassette_scan.scan_text}')"
    page << "$('#search_block').val(null)"
    page << "$('#currentBlock').val('#{block.specimenBlockID}')"
    if previous_block
      page << "$('#previousBlock').val('#{previous_block.specimenBlockID}')"
    end
  end
  
end
