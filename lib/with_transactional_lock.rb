# frozen_string_literal: true

require "with_transactional_lock/engine"

module WithTransactionalLock
  extend ActiveSupport::Autoload

  autoload :Mixin
end

ActiveSupport.on_load(:active_record) { include WithTransactionalLock::Mixin }
