module Webauthn
  module Rails
    class ApplicationController < ::ApplicationController
      private

      def sign_in(user)
        session[:user_id] = user.id
      end

      def sign_out
        session[:user_id] = nil
      end
    end
  end
end
