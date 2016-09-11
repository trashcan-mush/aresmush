module AresMUSH
  module Profile
    class CharProfileTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      def initialize(client, char)
        @char = char
        super client
      end
      
      def build
          text = "-~- %xh%xg#{@char.name}@#{Global.read_config("game", "name")}%xn -~-".center(78)
          text << "%r"
          text << status
          text << last_on
          text << timezone
          text << played_by
          text << alts
          text << custom_profile
          text << handle_notice
                    
          BorderedDisplay.text text
      end
      
      def format_field_title(title)
        "%R%xh#{left(title, 12)}%xn"
      end
      
      def status
        text = format_field_title t('profile.status')
        text << Chargen::Interface.approval_status(@char)
        text
      end
      
      def alts
        text = format_field_title t('profile.alts')
        text << Handles.get_visible_alts_name_list(@char, self.client.char)
        text << "%R%R#{t('profile.alts_notice')}"
        text
      end
      
      def played_by
        text = format_field_title t('profile.played_by')
        text << Actors::Interface.actor(@char)
        text
      end
      
      def last_on
        text = format_field_title t('profile.last_on')
        if (@char.client)
          text << t('profile.currently_connected')
        else
          text << OOCTime::Interface.local_long_timestr(self.client, Manage::Interface.last_on(@char))
        end
        text
      end
      
      def timezone
        text = format_field_title t('profile.timezone')
        text << OOCTime::Interface.timezone(@char)
        text
      end
      
      def custom_profile
        return "" if @char.profile.empty?
        Profile.format_custom_profile(@char)
      end
      
      def handle_notice
        if (@char.handle && @char.handle_visible_to?(@client.char))
          text = t('profile.see_handle_profile', :handle => @char.handle, :name => @char.name)          
          "%R%l2%R#{center(text, 78)}"
        else
          ""
        end
      end
    end
  end
end