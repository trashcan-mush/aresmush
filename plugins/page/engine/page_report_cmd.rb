module AresMUSH
  module Page
    class PageReportCmd
      include CommandHandler

      attr_accessor :name, :reason
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        self.name = titlecase_arg(args.arg1)
        self.reason = args.arg2
      end
      
      def required_args
        [ self.name, self.reason ]
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          if (enactor.is_monitoring?(model))            
            body = t('page.page_reported_body', :name => model.name)
            body << self.reason
            body << "%R-------%R"
            body << enactor.page_monitor[model.name].join("%R")
            Jobs.create_job(Jobs.request_category, t('page.page_reported_title'), body, enactor)
            client.emit_success t('page.log_reported')
          else
            client.emit_failure t('page.not_monitored', :name => model.name)
          end
        end
      end
    end
  end
end
