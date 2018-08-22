Spotlight::Resources::Dri::Engine.routes.draw do
  resources :exhibits, path: '/', only: [] do
      resource :dri_harvester, controller: :"spotlight/resources/dri_harvester", only: [:create, :update]
    end
end
