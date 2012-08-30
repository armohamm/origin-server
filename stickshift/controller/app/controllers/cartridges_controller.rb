class CartridgesController < BaseController
  respond_to :xml, :json
  before_filter :check_version
  
  def show
    index
  end
  
  # GET /cartridges
  def index
    type = params[:id]
    
    if type.nil?
      cartridges = CartridgeCache.cartridges
    else
      cartridges = CartridgeCache.find_cartridge_by_category(type)
    end
    
    rest_cartridges = cartridges.map do |cartridge|
      if $requested_api_version >= 1.1
        RestCartridge11.new(type, cartridge, nil, get_url, nolinks)
      else
        RestCartridge10.new(type, cartridge, nil, get_url, nolinks)
      end
    end
    
    render_success(:ok, "cartridges", rest_cartridges, "LIST_CARTRIDGES", "List #{type.nil? ? 'all' : type} cartridges") 
  end
end
