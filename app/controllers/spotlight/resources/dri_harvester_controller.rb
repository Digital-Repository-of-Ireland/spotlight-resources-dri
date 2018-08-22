
module Spotlight::Resources
  class DriHarvesterController < Spotlight::ApplicationController
    
    load_and_authorize_resource :exhibit, class: Spotlight::Exhibit
    
    # POST /dri_harvester
    def create
      
     my_params = resource_params
      
     harvester = Spotlight::Resources::DriHarvester.create(
        data: {base_url: resource_params[:url],
              user: resource_params[:user],
              token: resource_params[:token],
              ids: resource_params[:ids]},
        exhibit: current_exhibit)
        
      if !harvester.save_and_index
        flash[:notice] = t('spotlight.resources.dri_harvester.performharvest.failed')
        redirect_to spotlight.admin_exhibit_catalog_path(current_exhibit, sort: :timestamp)
      end 
      
      flash[:notice] = t('spotlight.resources.dri_harvester.performharvest.success')
      redirect_to spotlight.admin_exhibit_catalog_path(current_exhibit, sort: :timestamp)
    end
    
  private
        
    def resource_params
      params.require(:resources_dri_harvester).permit(:url, :user, :token, :ids)
    end
       
    
  end

end
