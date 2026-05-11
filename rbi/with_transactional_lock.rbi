# typed: strong
# frozen_string_literal: true

module WithTransactionalLock::Mixin::ClassMethods
  sig do
    type_parameters(:U)
      .params(lock_name: String, block: T.proc.returns(T.type_parameter(:U)))
      .returns(T.type_parameter(:U))
  end
  def with_transactional_lock(lock_name, &block); end
end
