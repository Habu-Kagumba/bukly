guard :rspec, cmd: "rspec -f d" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Rails files
  rails = dsl.rails()
  dsl.watch_spec_files_for(rails.app_files)

  watch(rails.controllers) do |m|
    [
      rspec.spec.("controllers/#{m[1]}_controller")
    ]
  end

  # Rails config changes
  watch(rails.spec_helper)     { rspec.spec_dir }
  watch(rails.routes)          { "#{rspec.spec_dir}/controllers" }
  watch(rails.app_controller)  { "#{rspec.spec_dir}/controllers" }

	begin
		require 'active_support/inflector'
		watch(%r{^spec/factories/(.+)_factory\.rb$})      { |m| ["app/models/#{m[1].singularize}.rb", "spec/models/#{m[1].singularize}_spec.rb"] }
	rescue LoadError
	end

end
