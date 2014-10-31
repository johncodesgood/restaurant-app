module Sinatra

  module Helpers

    def delete_button(action)
      "<form action='#{action}' method='post'>
      <input type='hidden' name='_method' value='delete'/></input>
      <input type='submit' value='Delete' id='button_small'></input></form>"
    end

    def patch_button(action, value)
      "<form action='#{action}' method='post'>
      <input type='hidden' name='_method' value='patch'/></input>
      <input type='submit' value='#{value}' id='button_small'></input></form>"
    end

    def get_button_small(action, value)
      "<form action='#{action}' method='get'>
      <input type='submit' value='#{value}' id='button_small'></input></form>"
    end

    def get_button_regular(action, value)
      "<form action='#{action}' method='get'>
      <input type='submit' value='#{value}'></input></form>"
    end

  end

  helpers Helpers

end
