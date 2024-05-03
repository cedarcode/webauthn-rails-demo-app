module Webauthn
  module Rails
    module Controllers
      module Helpers
        extend ActiveSupport::Concern

        def current_user
          @current_user ||=
            if session[:user_id]
              User.find_by(id: session[:user_id])
            end
        end

        ActiveSupport.on_load(:action_controller) do
          helper_method :current_user
        end
      end
    end
  end
end
