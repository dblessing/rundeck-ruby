# A sample Guardfile
# More info at https://github.com/guard/guard#readme
group :red_green_refactor, halt_on_fail: true do

  guard :rspec, cmd: 'bundle exec rspec' do
    watch(/^spec\/.+_spec\.rb$/)
    watch(/^lib\/(.+)\.rb$/)     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { 'spec' }
  end

  guard :rubocop do
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end

end
