module ApplicationHelper

  def smart_listing_render_controller name = controller_name, *args
    options = args.dup.extract_options!
    
    smart_listing_for(name, *args) do |smart_listing|
      concat(smart_listing.render_list(options[:locals]))
    end
  end
  
  def render_list locals = {}
    if @smart_listing.partial
      @template.render :partial => @smart_listing.partial, :locals => {:smart_listing => self}.merge(locals || {})
    end
  end

  # Helper copied from the smart_listing gem to see if it is to blame - it does not seem to be
  def smart_listing_foo *args
    options = args.extract_options!
    name = (args[0] || options[:name] || controller_name).to_sym
    smart_listing = @smart_listings[name]

    # don't update list if params are missing (prevents interfering with other lists)
    if params.keys.select{|k| k.include?("smart_listing")}.present? && !params[smart_listing.base_param]
      return unless options[:force]
    end

    builder = SmartListing::Helper::Builder.new(name, smart_listing, self, {}, nil)
    # binding.pry
    render(:partial => 'smart_listing/update_list', :locals => {
      :name => smart_listing.name,
      :part => smart_listing.partial,
      :smart_listing => builder,
      :smart_listing_data => {
        smart_listing_config.data_attributes(:params) => smart_listing.all_params,
        smart_listing_config.data_attributes(:max_count) => smart_listing.max_count,
        smart_listing_config.data_attributes(:item_count) => smart_listing.count,
      },
      :locals => options[:locals] || {}
    })
  end

  def admin?
    current_user.try(:admin?)
  end
end

