class LabelItemEngine

	def initialize(working_id, box_id)
		@working_state = WorkingState.find working_id
		@box_id = box_id
	end

	def add_items
		@working_state.label_items.all(:conditions => ["box_label_id = ?", 0]).each do |item|
      item.update_attributes(:box_label_id => @box_id)
    end
	end
	#handle_asynchronously :add_items

end