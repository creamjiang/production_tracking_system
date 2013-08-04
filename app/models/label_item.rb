class LabelItem < ActiveRecord::Base
	belongs_to :procedure_transaction
	belongs_to :box_label
	belongs_to :working_state

	attr_accessible :procedure_transaction_id, :box_label_id, :working_state_id
end
