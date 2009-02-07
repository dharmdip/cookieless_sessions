module CookielessSessions
end

class ::CGI #:nodoc:
  class Session #:nodoc:
    alias_method :initialize_without_uri_session_key, :initialize

    def initialize(cgi, options = {}, session_id=nil)
      key = options['session_key']

      if cgi.cookies[key].empty?
        if !session_id
          query = ENV['RAW_POST_DATA'] || cgi.query_string || ''
          session_id = CGI.parse(query)[key].first if cgi.cookies[key].empty?
        end
        if session_id
          cgi.params[key] = session_id
          options['session_id'] = cgi.params[key]
        end
      end
      @cgi = cgi
      initialize_without_uri_session_key(cgi, options)
    end
  end
end

# These enable the cookieless sessions required by some mobile phones and operators. 
ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS[:cookie_only] = false

module ActionController
  
  class Base
    # Technically, this is a protected method.  However, if you make it protected here and use restful
    # routes, then any route without parameters loses the session id.  So, users_url(:id => 1) has the 
    # session_key added, but users_url and users_path do not. 
    
    # TODO: Some phones cannot handle GET and POST parameters in the same request.  Ideally, it would be 
    # possible to prepend the session_key to the path, but this does not seem to be the case with routing
    # as it stands.
    
    # TODO: There ought to be a more elegant way of getting the session_key.  The problem with other methods
    # is that they do not pick up a custom key at initialization time. 
    def default_url_options(options = nil)
      session_key = ApplicationController.session.first[:session_key].to_sym
      { session_key => (request.xhr? ? params[session_key] : session.session_id) } if session[:cookies_off] == true
    end
  end
  
  class CgiRequest
    def session
      unless defined?(@session)
        if @session_options == false
          @session = Hash.new
        else
          stale_session_check! do
            if cookie_only? && query_parameters[session_options_with_string_keys['session_key']]
              raise SessionFixationAttempt
            end
            case value = session_options_with_string_keys['new_session']
              when true
                @session = new_session
              when false
                begin
                  @session = CGI::Session.new(@cgi, session_options_with_string_keys, query_parameters[session_options_with_string_keys['session_key']])
                # CGI::Session raises ArgumentError if 'new_session' == false
                # and no session cookie or query param is present.
                rescue ArgumentError
                  @session = Hash.new
                end
              when nil
                @session = CGI::Session.new(@cgi, session_options_with_string_keys, query_parameters[session_options_with_string_keys['session_key']])
              else
              raise ArgumentError, "Invalid new_session option: #{value}"
            end
            @session['__valid_session']
          end
        end
      end
      @session
    end
  end
end

