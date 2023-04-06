
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
              ids: resource_params[:ids],
              metadata: resource_params[:metadata]},
        exhibit: current_exhibit)

      if harvester.dri_objects.size == 0 || !harvester.save_and_index
        flash[:notice] = t('spotlight.resources.dri_harvester.performharvest.failed')
        redirect_to spotlight.admin_exhibit_catalog_path(current_exhibit, sort: :timestamp)
        return
      end

      flash[:notice] = t('spotlight.resources.dri_harvester.performharvest.success')
      redirect_to spotlight.admin_exhibit_catalog_path(current_exhibit, sort: :timestamp)
    end

  private

    def resource_params
      params.require(:resources_dri_harvester).permit(:url, :user, :token, :ids, :metadata, :exhibit_id)
    end
  end
end
