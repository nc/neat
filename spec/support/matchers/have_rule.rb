RSpec::Matchers.define :have_rule do |expected|
  match do |actual|
    @rules = get_rules_from_block(actual) || []
    @rules.include? expected
  end

  failure_message_for_should do |actual|
    if @rules.empty?
      %{no CSS rules for selector #{actual} were found}
    else
      %{expected #{actual} to have CSS rule "#{expected}"}
    end
  end

  def get_rules_from_block(actual)
    style_block = get_style_block(actual)
    unless style_block.empty?
      get_rules(style_block)
    end
  end

  def get_style_block(actual)
    block = ParserSupport.parser.find_by_selector(actual)
  end

  def get_rules(block)
    rules = []
    block.each do |ruleset|
      rules.concat(ruleset.split(';'))
    end
    rules.map!(&:strip)
  end
end
