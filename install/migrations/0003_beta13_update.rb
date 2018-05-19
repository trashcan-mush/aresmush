module AresMUSH
  module Migrations
    class MigrationBeta13Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Fixing scene config typo."
        
        config = DatabaseMigrator.read_config_file("scenes.yml")
        if (!config['scenes']['unshared_scene_deletion_days'])
          config['scenes']['unshared_scene_deletion_days'] = config['scenes']['unsared_scene_deletion_days'] || 20
        end
        config['scenes'].delete 'unsared_scene_deletion_days'
        DatabaseMigrator.write_config_file("scenes.yml", config)

        Global.logger.debug "Adding engine api proxy setting."
        config = DatabaseMigrator.read_config_file("website.yml")
        config['website']['use_api_proxy'] = false
        DatabaseMigrator.write_config_file("website.yml", config)
        
        
        Global.logger.debug "Adding desc tag colors."
        config = DatabaseMigrator.read_config_file("describe.yml")
        config['describe']['tag_colors'] = { "admin" => "%xb", "beginner" => "%xg"}
        DatabaseMigrator.write_config_file("describe.yml", config)
        
        
        Global.logger.debug "Changing hook shortcut."
        config = DatabaseMigrator.read_config_file("chargen.yml")
        shortcuts = config['chargen']['shortcuts']
        shortcuts.delete 'hook/set'
        shortcuts['hook/add'] = 'hook/set'
        config['chargen']['shortcuts'] = shortcuts
        DatabaseMigrator.write_config_file("chargen.yml", config)
        
                     
      end
    end
  end
end