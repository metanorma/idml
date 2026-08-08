# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  skip "/spec/"
end

require "pdfrb"
require "idml"

# Writes a rendered PDF to a temp directory and yields the path.
# Use this in specs instead of `Tempfile.new(...).path` followed by
# `writer.write(path)` — that pattern races with the Tempfile finalizer
# (the object is collected between `.path` and `writer.write`, deleting
# the file before pdfrb opens it). The block form keeps the directory
# alive for the duration of the test body.
def write_to_temp_pdf(writer, prefix = "idml-spec")
  require "tmpdir"
  Dir.mktmpdir(prefix) do |dir|
    path = File.join(dir, "out.pdf")
    writer.write(path)
    yield path
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = "doc" if config.files_to_run.one?

  config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed
end
