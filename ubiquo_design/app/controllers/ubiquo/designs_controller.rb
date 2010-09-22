class Ubiquo::DesignsController < UbiquoAreaController

  include UbiquoDesign::RenderPage
  helper :pages

  ubiquo_config_call :design_access_control, {:context => :ubiquo_design}
  uses_tiny_mce(:options => default_tiny_mce_options.merge(:entities => ''))

  def show
    @page = Page.find(params[:page_id])
    @template_content = render_page_to_string(@page)
    @widgets = @page.available_widgets.sort_by(&:to_s)
  end

  def preview
    page = Page.find(params[:page_id])
    render_page(page)
  end

  def publish
    page = Page.find(params[:page_id])
    if page.publish
      flash[:notice] = t('ubiquo.design.page_published')
    else
      flash[:error] = t('ubiquo.design.page_publish_error')
    end
    redirect_to :action => "show"
  end

  def render_page_to_string(page)
    template_file = Rails.root.join("app/templates/#{page.page_template.key}/ubiquo.html.erb").to_s
    template_contents = render_to_string :file => template_file,
                                         :locals => {:page => page}
    render_to_string :partial => 'template',
                     :locals => {:template_contents => template_contents, :page => page}
  end
end
