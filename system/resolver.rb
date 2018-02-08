module Dry
  module Hanami
    module Resolver
      PROJECT_NAME = ::Hanami::Environment.new.project_name

      def register_folder!(folder, resolver: ->(k) { k.new })
        all_files_in_folder(folder).each do |file|
          register_name = file.sub("#{PROJECT_NAME}/", '').gsub('/', '.').gsub(/_repository\z/, '')
          register(register_name, memoize: true) { load! file, resolver: resolver }
        end
      end

      def register_folder_in_app!(folder, resolver: ->(k) { k.new })
        alls_files_in_apps(folder).each do |file|
          register_name = file.sub("#{PROJECT_NAME}/", '').gsub('/', '.').gsub(/_repository\z/, '')
          register(register_name, memoize: true) { load_inside_app! file, resolver: resolver }
        end
      end

      def all_files_in_folder(folder)
        Dir
          .entries("#{::Hanami.root}/lib/#{folder}")
          .select {|f| !File.directory? f}
          .map! { |file_name| "#{folder}/#{file_name.sub!('.rb', '')}" }
      end

      def alls_files_in_apps(folder)
        Dir
          .entries("#{::Hanami.root}/apps/#{folder}")
          .select {|f| !File.directory? f}
          .map! { |file_name| "#{folder}/#{file_name.sub!('.rb', '')}" }
      end

      def load!(path, resolver: ->(k) { k.new })
        load_file!(path)

        unnecessary_part = path[/repositories/] ? "#{PROJECT_NAME}/repositories" : "#{PROJECT_NAME}/"
        right_path = path.sub(unnecessary_part, '')

        resolver.call(Object.const_get(Inflecto.classify(right_path).sub('Statu', 'Status')))
      end

      def load_inside_app!(path, resolver: ->(k) { k.new })
        load_app_file!(path)

        unnecessary_part = path[/repositories/] ? "#{PROJECT_NAME}/repositories" : "#{PROJECT_NAME}/"
        right_path = path.sub(unnecessary_part, '')

        resolver.call(Object.const_get(Inflecto.classify(right_path).sub('Statu', 'Status')))
      end


      def load_file!(path)
        require_relative "#{::Hanami.root}/lib/#{path}"
      end

      def load_app_file!(path)
        require_relative "#{::Hanami.root}/apps/#{path}"
      end
    end
  end
end
