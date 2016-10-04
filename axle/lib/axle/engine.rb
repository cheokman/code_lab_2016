module Axle
  class Engine < ::Rails::Engine
    isolate_namespace Axle
    engine_name 'axle'

    config.after_initialize do |app|
      if Axle.mount_at
        app.routes.prepend do
          mount Axle::Engine => Axle.mount_at, as: "#{Axle.service_base_path}"
        end
      end
    end
  end
end