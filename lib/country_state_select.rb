require 'country_state_select/version'
require 'city-state'
require 'rails'
require 'sass-rails'
require 'compass-rails'
require 'chosen-rails'
require 'simple_form'

# @author : Adam De Fouw
module CountryStateSelect

  # Collect the Countries
  def self.countries_collection
    CS.countries.except!(:COUNTRY_ISO_CODE).collect {|p| [p[ 1],p[0]] }.compact
  end

  # Pass array of unwanted countries to get back all except those in the array
  def self.countries_except(*except)
    countries_collection.collect { |c| c unless except.include?(c.second) }.compact
  end

  # Return either the State (String) or States (Array)
  def self.states_collection(f, options)
    states = collect_states(f.object.send(options[:country]))
    return f.object.send(options[:state]) if states.size == 0
    states
  end

  # Return the collected States for a given Country
  def self.collect_states(country)
    country = countries_collection.first.second if country.nil?
    CS.states(country).collect {|p| [ p[1], p[0] ] }.compact
  end

  #Return the cities of given state and country
  def self.collect_cities(state_id = '', country_id = '')
    country_id = countries_collection.first.second if country_id.nil?
    state_id = CS.states(country_id).first.first if state_id.nil?
    CS.cities(state_id.to_sym, country_id.to_sym)
  end

  # Return a hash for use in the simple_form
  def self.state_options(options)
    states = states_collection(options[:form], options[:field_names])
    options = options.merge(collection: states)
    options = options.merge(:as => :string) if states.class == String
    options
  end

end

case ::Rails.version.to_s
when /^4/
  require 'country_state_select/engine'
when /^3\.[12]/
  require 'country_state_select/engine3'
when /^3\.[0]/
  require 'country_state_select/railtie'
else
  fail 'Unsupported rails version'
end
