# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131112074036) do

# Could not dump table "account_statements" because of following StandardError
#   Unknown type 'year(4)' for column 'account_year'

  create_table "administrators", :force => true do |t|
    t.string   "name",            :limit => 100
    t.string   "login",           :limit => 45
    t.string   "hashed_password"
    t.string   "salt"
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.string   "employee_number",                :null => false
  end

  create_table "attached_products", :force => true do |t|
    t.integer  "machine_id"
    t.integer  "product_id"
    t.boolean  "visible",              :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "routing_procedure_id"
    t.integer  "routing_id"
    t.integer  "routing_process_id"
    t.string   "part_name"
    t.integer  "bin_type_id",          :default => 0
  end

  add_index "attached_products", ["bin_type_id"], :name => "index_attached_products_on_bin_type_id"
  add_index "attached_products", ["machine_id"], :name => "index_attached_products_on_machine_id"
  add_index "attached_products", ["product_id"], :name => "index_attached_products_on_product_id"

  create_table "bin_clearing_records", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "bin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bin_clearing_records", ["bin_id"], :name => "index_bin_clearing_records_on_bin_id"
  add_index "bin_clearing_records", ["employee_id"], :name => "index_bin_clearing_records_on_employee_id"

  create_table "bin_statuses", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bin_types", :force => true do |t|
    t.string   "name",                   :limit => 45
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "maximum_load",                         :default => 0
    t.string   "bin_barcode_format"
    t.string   "bin_barcode_text"
    t.string   "product_barcode_format"
    t.string   "product_barcode_text"
  end

  create_table "bins", :force => true do |t|
    t.string   "bin_number",    :limit => 45
    t.integer  "bin_type_id"
    t.integer  "bin_status_id",               :default => 1
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bins", ["bin_status_id"], :name => "index_bins_on_bin_status_id"
  add_index "bins", ["bin_type_id"], :name => "index_bins_on_bin_type_id"

  create_table "box_labels", :force => true do |t|
    t.string   "code",            :limit => 12
    t.integer  "product_id",                    :default => 0, :null => false
    t.integer  "machine_id",                    :default => 0, :null => false
    t.integer  "quantity",                      :default => 0, :null => false
    t.integer  "employee_id",                   :default => 0, :null => false
    t.datetime "boxed_date_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "box_labels", ["code"], :name => "index_box_labels_on_code"
  add_index "box_labels", ["employee_id"], :name => "index_box_labels_on_employee_id"
  add_index "box_labels", ["machine_id"], :name => "index_box_labels_on_machine_id"
  add_index "box_labels", ["product_id"], :name => "index_box_labels_on_product_id"

  create_table "categories", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cold_store_accounts", :force => true do |t|
    t.integer  "product_id"
    t.date     "report_on"
    t.integer  "opening_balance", :default => 0
    t.integer  "debit",           :default => 0
    t.integer  "credit",          :default => 0
    t.integer  "closing_balance", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cold_store_accounts", ["product_id"], :name => "index_cold_store_accounts_on_product_id"

  create_table "cold_stores", :force => true do |t|
    t.integer  "procedure_transaction_id",              :default => 0
    t.date     "on_hold_date"
    t.date     "converted_date"
    t.integer  "status",                   :limit => 2, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "administrator_id",                      :default => 0
    t.integer  "product_id",                            :default => 0
    t.integer  "quantity"
  end

  add_index "cold_stores", ["administrator_id"], :name => "index_cold_stores_on_administrator_id"
  add_index "cold_stores", ["procedure_transaction_id"], :name => "index_cold_stores_on_procedure_transaction_id"
  add_index "cold_stores", ["product_id"], :name => "index_cold_stores_on_product_id"
  add_index "cold_stores", ["quantity"], :name => "index_cold_stores_on_quantity"

  create_table "containers", :force => true do |t|
    t.integer  "product_id"
    t.integer  "bin_type_id"
    t.integer  "maximum_load", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "containers", ["bin_type_id"], :name => "index_containers_on_bin_type_id"
  add_index "containers", ["product_id"], :name => "index_containers_on_product_id"

  create_table "daily_transactions", :id => false, :force => true do |t|
    t.integer  "id",                                                                                 :null => false
    t.date     "transaction_date",                                                                   :null => false
    t.integer  "routing_id",                                                     :default => 0,      :null => false
    t.integer  "routing_process_id",                                             :default => 0,      :null => false
    t.integer  "product_id",                                                     :default => 0,      :null => false
    t.string   "generic_name",       :limit => 50,                               :default => "None", :null => false
    t.string   "side",               :limit => 1,                                :default => "Z",    :null => false
    t.string   "reject_code",        :limit => 15,                               :default => "None", :null => false
    t.integer  "quantity",                                                       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reject_area",        :limit => 2,                                :default => "00"
    t.decimal  "part_cost",                        :precision => 6, :scale => 2
  end

  add_index "daily_transactions", ["reject_area"], :name => "index_daily_transactions_on_reject_area"

  create_table "departments", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alias",       :limit => 45
    t.boolean  "builtin",                   :default => false
    t.integer  "position",                  :default => 1
  end

  create_table "destinations", :force => true do |t|
    t.integer  "warehouse_id",               :null => false
    t.string   "name",         :limit => 45
    t.string   "location",     :limit => 45
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "destinations", ["warehouse_id"], :name => "index_destinations_on_warehouse_id"

  create_table "efficiency_schedules", :force => true do |t|
    t.date     "schedule_date",                          :null => false
    t.integer  "product_id",                             :null => false
    t.string   "part_name",                              :null => false
    t.string   "shift_type",                             :null => false
    t.string   "shift",                                  :null => false
    t.time     "start_time",                             :null => false
    t.time     "end_time",                               :null => false
    t.integer  "operators_present",                      :null => false
    t.integer  "expected_output",                        :null => false
    t.string   "operation_status",                       :null => false
    t.integer  "machine_down_reason_id", :default => 0
    t.string   "down_reason_code",       :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration",               :default => 0
  end

  create_table "employees", :force => true do |t|
    t.string   "employee_number", :limit => 45
    t.string   "name",            :limit => 100
    t.string   "hashed_password"
    t.string   "salt",            :limit => 25
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
  end

  add_index "employees", ["department_id"], :name => "index_employees_on_department_id"

  create_table "export_items", :force => true do |t|
    t.integer  "prms_export_id",                          :null => false
    t.integer  "routing_procedure_id",                    :null => false
    t.integer  "destination_id",       :default => 0,     :null => false
    t.integer  "export_quantity",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id",                              :null => false
    t.integer  "routing_id",                              :null => false
    t.integer  "routing_process_id",                      :null => false
    t.integer  "account_statement_id",                    :null => false
    t.integer  "warehouse_id",         :default => 0
    t.integer  "stock_quantity",       :default => 0
    t.boolean  "posted",               :default => false
    t.integer  "transfered_quantity",  :default => 0
  end

  add_index "export_items", ["account_statement_id"], :name => "index_export_items_on_account_statement_id"
  add_index "export_items", ["destination_id"], :name => "index_export_items_on_destination_id"
  add_index "export_items", ["posted"], :name => "index_export_items_on_posted"
  add_index "export_items", ["prms_export_id"], :name => "index_export_items_on_prms_export_id"
  add_index "export_items", ["routing_id"], :name => "index_export_items_on_routing_id"
  add_index "export_items", ["routing_procedure_id"], :name => "index_export_items_on_routing_procedure_id"
  add_index "export_items", ["routing_process_id"], :name => "index_export_items_on_routing_process_id"
  add_index "export_items", ["warehouse_id"], :name => "index_export_items_on_warehouse_id"

  create_table "flush_accounts", :force => true do |t|
    t.integer  "procedure_transaction_id", :null => false
    t.integer  "export_item_id",           :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",                 :null => false
  end

  add_index "flush_accounts", ["export_item_id"], :name => "index_flush_accounts_on_export_item_id"
  add_index "flush_accounts", ["procedure_transaction_id"], :name => "index_flush_accounts_on_procedure_transaction_id"

  create_table "groups", :force => true do |t|
    t.string   "name",        :limit => 45
    t.string   "alias",       :limit => 45
    t.text     "description"
    t.boolean  "builtin",                   :default => false
    t.integer  "position",                  :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "input_machines", :force => true do |t|
    t.integer  "machine_id"
    t.integer  "material_input_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "input_machines", ["machine_id"], :name => "index_input_machines_on_machine_id"
  add_index "input_machines", ["material_input_id"], :name => "index_input_machines_on_material_input_id"

  create_table "label_items", :force => true do |t|
    t.integer  "working_state_id",                        :null => false
    t.integer  "procedure_transaction_id",                :null => false
    t.integer  "box_label_id",             :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "label_items", ["box_label_id"], :name => "index_label_items_on_box_label_id"
  add_index "label_items", ["procedure_transaction_id"], :name => "index_label_items_on_procedure_transaction_id"
  add_index "label_items", ["working_state_id"], :name => "index_label_items_on_working_state_id"

  create_table "login_records", :force => true do |t|
    t.integer  "employee_id"
    t.integer  "machine_id"
    t.boolean  "logout",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "login_records", ["employee_id"], :name => "index_login_records_on_employee_id"
  add_index "login_records", ["machine_id"], :name => "index_login_records_on_machine_id"

  create_table "machine_down_reasons", :force => true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",               :limit => 45
    t.string   "alias"
    t.integer  "routing_process_id",               :default => 1
  end

  add_index "machine_down_reasons", ["routing_process_id"], :name => "index_machine_down_reasons_on_routing_process_id"

  create_table "machine_downtimes", :force => true do |t|
    t.integer  "machine_id",             :default => 0
    t.integer  "employee_id",            :default => 0
    t.integer  "routing_id",             :default => 0
    t.integer  "routing_process_id",     :default => 0
    t.integer  "routing_procedure_id",   :default => 0
    t.integer  "bin_id",                 :default => 0
    t.integer  "bin_type_id",            :default => 0
    t.integer  "product_id",             :default => 0
    t.integer  "machine_down_reason_id", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "container_id",           :default => 0
    t.boolean  "fixed",                  :default => true
    t.integer  "shift_id",               :default => 0
    t.date     "down_date"
    t.datetime "fixed_time"
    t.datetime "confirmed_reason_time"
  end

  add_index "machine_downtimes", ["bin_id"], :name => "index_machine_downtimes_on_bin_id"
  add_index "machine_downtimes", ["bin_type_id"], :name => "index_machine_downtimes_on_bin_type_id"
  add_index "machine_downtimes", ["container_id"], :name => "index_machine_downtimes_on_container_id"
  add_index "machine_downtimes", ["employee_id"], :name => "index_machine_downtimes_on_employee_id"
  add_index "machine_downtimes", ["machine_down_reason_id"], :name => "index_machine_downtimes_on_machine_down_reason_id"
  add_index "machine_downtimes", ["machine_id"], :name => "index_machine_downtimes_on_machine_id"
  add_index "machine_downtimes", ["product_id"], :name => "index_machine_downtimes_on_product_id"
  add_index "machine_downtimes", ["routing_id"], :name => "index_machine_downtimes_on_routing_id"
  add_index "machine_downtimes", ["routing_procedure_id"], :name => "index_machine_downtimes_on_routing_procedure_id"
  add_index "machine_downtimes", ["routing_process_id"], :name => "index_machine_downtimes_on_routing_process_id"

  create_table "machines", :force => true do |t|
    t.string   "machine_number",    :limit => 45
    t.string   "asset_number",      :limit => 45
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "down",                            :default => false
    t.string   "mac_address",       :limit => 45
    t.integer  "entry_category_id",               :default => 0
    t.string   "scan_folder"
  end

  add_index "machines", ["entry_category_id"], :name => "index_machines_on_entry_category_id"

  create_table "material_inputs", :force => true do |t|
    t.integer  "material_id"
    t.string   "lot_number",  :limit => 45
    t.integer  "quantity",                  :default => 0
    t.string   "uom",         :limit => 20
    t.datetime "start_time"
    t.datetime "finish_time"
    t.date     "input_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "material_inputs", ["material_id"], :name => "index_material_inputs_on_material_id"

  create_table "materials", :force => true do |t|
    t.string   "raw_code",    :limit => 45
    t.string   "name",        :limit => 45
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operators", :force => true do |t|
    t.integer  "machine_id"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "operators", ["employee_id"], :name => "index_operators_on_employee_id"
  add_index "operators", ["machine_id"], :name => "index_operators_on_machine_id"

  create_table "photos", :force => true do |t|
    t.integer  "reject_code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
  end

  add_index "photos", ["reject_code_id"], :name => "index_photos_on_reject_code_id"

  create_table "prms_exports", :force => true do |t|
    t.date     "export_date",                              :null => false
    t.string   "remark"
    t.integer  "administrator_id",                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.boolean  "posted",                :default => false
    t.boolean  "disabled",              :default => false
  end

  add_index "prms_exports", ["administrator_id"], :name => "index_prms_exports_on_administrator_id"
  add_index "prms_exports", ["disabled"], :name => "index_prms_exports_on_disabled"
  add_index "prms_exports", ["export_date"], :name => "index_prms_exports_on_export_date"
  add_index "prms_exports", ["posted"], :name => "index_prms_exports_on_posted"

  create_table "procedure_admins", :force => true do |t|
    t.integer  "administrator_id"
    t.integer  "routing_procedure_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "procedure_admins", ["administrator_id"], :name => "index_procedure_admins_on_administrator_id"
  add_index "procedure_admins", ["routing_procedure_id"], :name => "index_procedure_admins_on_routing_procedure_id"

  create_table "procedure_machines", :force => true do |t|
    t.integer  "routing_procedure_id"
    t.integer  "machine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "suspend",              :default => false
    t.integer  "routing_id"
  end

  add_index "procedure_machines", ["machine_id"], :name => "index_procedure_machines_on_machine_id"
  add_index "procedure_machines", ["routing_id"], :name => "index_procedure_machines_on_routing_id"
  add_index "procedure_machines", ["routing_procedure_id"], :name => "index_procedure_machines_on_routing_procedure_id"

  create_table "procedure_processes", :force => true do |t|
    t.integer  "routing_procedure_id", :default => 0
    t.integer  "routing_process_id",   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procedure_products", :force => true do |t|
    t.string   "generic_name", :limit => 45
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procedure_transactions", :force => true do |t|
    t.integer  "routing_procedure_id",                                             :default => 0
    t.integer  "employee_id",                                                      :default => 0
    t.integer  "product_id",                                                       :default => 0
    t.integer  "machine_id",                                                       :default => 0
    t.integer  "routing_id",                                                       :default => 0
    t.integer  "routing_process_id",                                               :default => 0
    t.integer  "bin_id",                                                           :default => 0
    t.integer  "bin_type_id",                                                      :default => 0
    t.integer  "status",               :limit => 2,                                :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "container_id",                                                     :default => 0
    t.integer  "reject_code_id",                                                   :default => 0
    t.date     "transaction_date"
    t.integer  "shift_id",                                                         :default => 0
    t.integer  "quantity",                                                         :default => 1
    t.string   "generic_name",         :limit => 90,                               :default => "None"
    t.string   "reject_area",          :limit => 2,                                :default => "00"
    t.decimal  "part_cost",                          :precision => 6, :scale => 2
  end

  add_index "procedure_transactions", ["bin_id"], :name => "index_procedure_transactions_on_bin_id"
  add_index "procedure_transactions", ["bin_type_id"], :name => "index_procedure_transactions_on_bin_type_id"
  add_index "procedure_transactions", ["container_id"], :name => "index_procedure_transactions_on_container_id"
  add_index "procedure_transactions", ["employee_id"], :name => "index_procedure_transactions_on_employee_id"
  add_index "procedure_transactions", ["generic_name"], :name => "index_procedure_transactions_on_generic_name"
  add_index "procedure_transactions", ["machine_id"], :name => "index_procedure_transactions_on_machine_id"
  add_index "procedure_transactions", ["product_id"], :name => "index_procedure_transactions_on_product_id"
  add_index "procedure_transactions", ["quantity"], :name => "index_procedure_transactions_on_quantity"
  add_index "procedure_transactions", ["reject_area"], :name => "index_procedure_transactions_on_reject_area"
  add_index "procedure_transactions", ["reject_code_id"], :name => "index_procedure_transactions_on_reject_code_id"
  add_index "procedure_transactions", ["routing_id"], :name => "index_procedure_transactions_on_routing_id"
  add_index "procedure_transactions", ["routing_procedure_id"], :name => "index_procedure_transactions_on_routing_procedure_id"
  add_index "procedure_transactions", ["routing_process_id"], :name => "index_procedure_transactions_on_routing_process_id"
  add_index "procedure_transactions", ["shift_id"], :name => "index_procedure_transactions_on_shift_id"

  create_table "product_balances", :force => true do |t|
    t.integer  "product_id",                          :null => false
    t.string   "generic_name",                        :null => false
    t.integer  "quantity_in",          :default => 0
    t.integer  "quantity_out",         :default => 0
    t.integer  "balance",              :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "routing_id",           :default => 0
    t.integer  "routing_process_id",   :default => 0
    t.integer  "routing_procedure_id", :default => 0
  end

  add_index "product_balances", ["balance"], :name => "index_product_balances_on_balance"
  add_index "product_balances", ["product_id"], :name => "index_product_balances_on_product_id"
  add_index "product_balances", ["routing_id"], :name => "index_product_balances_on_routing_id"
  add_index "product_balances", ["routing_procedure_id"], :name => "index_product_balances_on_routing_procedure_id"
  add_index "product_balances", ["routing_process_id"], :name => "index_product_balances_on_routing_process_id"

  create_table "products", :force => true do |t|
    t.string   "part_number",                :limit => 45
    t.string   "description",                :limit => 45
    t.integer  "category_id",                                                            :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "customer",                   :limit => 45
    t.string   "part_name",                  :limit => 45
    t.string   "side",                       :limit => 10
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "containers_count",                                                       :default => 0
    t.string   "generic_name",               :limit => 45,                               :default => "0"
    t.string   "technology",                 :limit => 45
    t.string   "processed_parts",            :limit => 45
    t.string   "processed_part_description", :limit => 45
    t.string   "prms_description",           :limit => 45
    t.string   "prms_description_1",         :limit => 45
    t.integer  "reject_area_category",       :limit => 1,                                :default => 8
    t.decimal  "part_cost",                                :precision => 6, :scale => 2
    t.decimal  "part_weight",                              :precision => 6, :scale => 2
  end

  add_index "products", ["reject_area_category"], :name => "index_products_on_reject_area"

  create_table "reject_codes", :force => true do |t|
    t.string   "code",               :limit => 45
    t.text     "description"
    t.integer  "routing_process_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alias",              :limit => 45
    t.boolean  "active",                           :default => true
    t.datetime "deactived_time"
  end

  create_table "routine_products", :force => true do |t|
    t.integer  "routing_procedure_id", :default => 0
    t.integer  "product_id",           :default => 0
    t.integer  "warehouse_id",         :default => 0
    t.boolean  "reject_include",       :default => false
    t.integer  "bin_type_id",          :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "routine_products", ["bin_type_id"], :name => "index_routine_products_on_bin_type_id"
  add_index "routine_products", ["product_id"], :name => "index_routine_products_on_product_id"
  add_index "routine_products", ["routing_procedure_id"], :name => "index_routine_products_on_routing_procedure_id"
  add_index "routine_products", ["warehouse_id"], :name => "index_routine_products_on_warehouse_id"

  create_table "routing_procedures", :force => true do |t|
    t.integer  "routing_id"
    t.integer  "routing_process_id"
    t.integer  "position",           :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "routing_procedures", ["routing_id"], :name => "index_routing_procedures_on_routing_id"
  add_index "routing_procedures", ["routing_process_id"], :name => "index_routing_procedures_on_routing_process_id"

  create_table "routing_processes", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routings", :force => true do |t|
    t.string   "name",        :limit => 45
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "suspend",                   :default => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.boolean  "register_bin_with_scanner", :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enable_flush",              :default => false
  end

  create_table "shift_items", :force => true do |t|
    t.integer  "machine_id"
    t.integer  "shift_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shift_items", ["machine_id"], :name => "index_shift_items_on_machine_id"
  add_index "shift_items", ["shift_id"], :name => "index_shift_items_on_shift_id"

  create_table "shifts", :force => true do |t|
    t.string   "name",        :limit => 45
    t.time     "time_start"
    t.time     "time_end"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_summaries", :force => true do |t|
    t.integer  "employee_id",                                        :default => 0
    t.integer  "machine_id",                                         :default => 0
    t.integer  "product_id",                                         :default => 0
    t.integer  "routing_procedure_id",                               :default => 0
    t.integer  "routing_process_id",                                 :default => 0
    t.integer  "routing_id",                                         :default => 0
    t.integer  "shift_id",                                           :default => 0
    t.integer  "good_unit",                                          :default => 0
    t.integer  "reject_unit",                                        :default => 0
    t.integer  "hold_unit",                                          :default => 0
    t.date     "processing_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "part_cost",            :precision => 6, :scale => 2
  end

  add_index "transaction_summaries", ["employee_id"], :name => "index_transaction_summaries_on_employee_id"
  add_index "transaction_summaries", ["machine_id"], :name => "index_transaction_summaries_on_machine_id"
  add_index "transaction_summaries", ["processing_date"], :name => "index_transaction_summaries_on_processing_date"
  add_index "transaction_summaries", ["product_id"], :name => "index_transaction_summaries_on_product_id"
  add_index "transaction_summaries", ["routing_procedure_id"], :name => "index_transaction_summaries_on_routing_procedure_id"
  add_index "transaction_summaries", ["shift_id"], :name => "index_transaction_summaries_on_shift_id"

  create_table "warehouses", :force => true do |t|
    t.string   "name",       :limit => 45
    t.string   "location",   :limit => 45
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "working_states", :force => true do |t|
    t.integer  "product_id"
    t.integer  "bin_type_id"
    t.integer  "routing_procedure_id"
    t.integer  "loaded_unit",          :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "machine_id"
    t.integer  "attached_product_id"
    t.integer  "maximum_load",         :default => 0, :null => false
  end

  add_index "working_states", ["attached_product_id"], :name => "index_working_states_on_attached_product_id"
  add_index "working_states", ["bin_type_id"], :name => "index_working_states_on_bin_id"
  add_index "working_states", ["bin_type_id"], :name => "index_working_states_on_bin_type_id"
  add_index "working_states", ["machine_id"], :name => "index_working_states_on_machine_id"
  add_index "working_states", ["product_id"], :name => "index_working_states_on_product_id"
  add_index "working_states", ["routing_procedure_id"], :name => "index_working_states_on_routing_procedure_id"

end
