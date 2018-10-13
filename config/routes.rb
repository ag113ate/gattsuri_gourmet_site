GattsuriGourmetSite::Application.routes.draw do
  root 'gourmet_sites#top'
  
  get "gourmet_sites/disp_search_result"
  get "gourmet_sites/select_city"
  
  post   "gourmet_sites/bookmark/:id" => "gourmet_sites#add_bookmark"
  delete "gourmet_sites/bookmark/:id" =>"gourmet_sites#del_bookmark"
  
  resources :users
  post "users/login"
  post "users/logout"
  get "users/:id/delete_confirm" => "users#delete_confirm"
  
  # resources :reviews
  get "reviews/:store_id/new/" => "reviews#new"
  get "reviews/:store_id" => "reviews#show"
  get "reviews/:store_id/:vote_id/edit" => "reviews#edit"
  
  post "reviews/:store_id/:vote_id" => "reviews#create"
  
  patch "reviews/:store_id/:vote_id" => "reviews#update"
  put   "reviews/:store_id/:vote_id" => "reviews#update"
  
  delete "reviews/:store_id/:vote_id" => "reviews#delete"
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
