ActionController::Routing::Routes.draw do |map|

  map.resources :box_labels, :only => [:index, :show, :edit, :update], :member => {:print_barcode => :get}
  map.resources :efficiency_schedules

  map.resources :prms_exports, :member => {:download => :get, :sources => :get, :update_items => :post, :post_items => :get}

  map.resources :account_statements

  map.resources :warehouses, :member => {:remove_item => :post, :add_item => :post},
                             :collection => {:add_routine_product => :post, :routine_product => :get, :assign => :get, :update_procedure => :post}

  map.resources :settings

  map.resources :cold_store_accounts

  map.resources :transaction_summaries

  map.resources :shift_items

  map.resources :shifts

  map.resources :cold_stores, :collection => {:add_good_unit => :post, :add_reject_unit => :post, :show_reject_photo => :get}

  map.resources :material_inputs, :member => {:add_machines => :post, :attach_machines => :get, :remove_machine => :get}

  map.resources :procedure_products

  #map.connect '/login/unauthorized_user', :controller => 'login', :action => 'unauthorized_user'
  #map.connect '/login/unauthorized_admin', :controller => 'login', :action => 'unauthorized_admin'
  #map.login '/login/production_index', :controller => 'login', :action => 'production_index'
  map.login '/login', :controller => 'login', :action => 'index'
  map.admin '/admin', :controller => 'login', :action => 'admin_index'
  map.supervisor '/supervisor', :controller => 'login', :action => 'production_report_index'
  map.logout '/logout', :controller => 'login', :action => 'logout'
 
  map.resources :groups

  map.resources :procedure_machines

  map.resources :login_records, :member => {:unfreeze => :get}

  map.resources :machine_downtimes

  map.resources :bin_clearing_records

  map.resources :machine_down_reasons

  map.resources :procedure_transactions

  map.resources :working_states

  map.resources :containers

  map.resources :bin_statuses

  map.resources :bin_types, :member => {:remove_product => :get}

  map.resources :bins, :collection => {:clear => :get, :list_bin_types => [:get, :post]}, :member => {:list_full => [:get, :post]}
  
  map.resources :reject_codes

  map.resources :operators

  map.resources :machines, :member => {:attach_employee => :get, :attach_product => :get, :add_operator => :post, 
                                       :add_product => :post,  :remove_employee => [:get, :post],  :remove_product => :get, 
                                       :update_visible => :post, :attach_shift => :get, :add_shift => :post, 
                                       :remove_shift => [:get, :post], :update_process => :post, :initial_bin => :get},
                            :collection => {:update_process_info => :post}

  map.resources :materials

  map.resources :administrators, :member => {:change_password => :get, :attach_procedure => :get, :add_procedure => :post, :remove_procedure => :get }

  map.resources :departments

  map.resources :employees, :member => {:change_password => :get}

  map.resources :routings, :has_many => :routing_procedures, 
                           :member => {:add_process => :get, :attach_process => :post, :remove_process => :get,
                           :add_procedure => :get, :attach_procedure => :post,:remove_procedure => :get,
                           :add_machine => :get, :attach_machine => :post , :remove_machine => :get ,
                           :update_sequence => :post, :show_employees => :get, :show_products => :get, :show_machines => :get,
                           :enable => :get, :disable => :get}

  map.resources :routing_processes

  map.resources :categories

  map.resources :products, :member => {:add_operator => :get}, :collection => {:import_csv => :get}

  map.connect 'efficiency_schedules/:action/:id', :controller => 'efficiency_schedules'
  map.connect 'cold_stores/:action/:id', :controller => 'cold_stores'
  map.connect 'bin_types/:action/:id', :controller => 'bin_types'
  map.connect 'reject_codes/:action/:id', :controller => 'reject_codes'
  map.connect '/bins/:action/:id' , :controller => 'bins'
  map.connect '/graph/:action/:id', :controller => "graph"
  map.connect '/login/:action/:id', :controller => 'login'
  map.connect '/main/:action/:id', :controller => 'main'
  map.connect '/flow/:action/:id', :controller => 'flow'
  map.connect '/production_report/:action/:id', :controller => 'production_report'
  map.connect '/employees/:action/:id', :controller => 'employees'
  map.connect '/administrators/:action/:id', :controller => 'administrators'

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
   map.root :controller => "login"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
