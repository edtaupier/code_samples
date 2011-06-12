class Qa::ManifestController < QaController
  
  def view

  end

  def options

  end

  def report
    @presenter = QaManifestPresenter.new(params[:start_date], params[:end_date], params[:case_id], params[:location_id])
    render :pdf => "Manifest", :template=>"qa/manifest/report",
                                 :layout=>"manifest",
                                 :orientation=>"landscape", 
#                                 :show_as_html=>true,
                                 :margin=>{:top=>4, :bottom=>4, :left=>3, :right=>1},
                                 :footer=> {:html=>{:template=>"qa/manifest/footer.pdf.erb"}}
  end

end
