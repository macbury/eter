module BrowserMacro
  BROWSER_KEY_DOWN  = 40
  BROWSER_KEY_UP    = 38
  BROWSER_KEY_ENTER = 13

  def visit_hash(hash_path)
    visit("/" + hash_path)
  end

  def open_sense_menu
    find(".sense-open").click
  end

  def page_trigger_key_on(field_css_id, key)
    result = page.driver.evaluate_script <<-EOS
      function() {
        var input  = angular.element("#{field_css_id}");

        if (input.size() != 1) {
          return false;
        } else {
          var e      = angular.element.Event("keydown");
          e.which    = #{key};
          e.keyCode  = #{key};
          input.trigger(e);
          return true;
        }
      }();
    EOS
    unless result
      raise "Could not find element #{field_css_id.inspect}"
    end
  end


  def jquery_element_count(jquery_query)
    page.driver.evaluate_script <<-EOS
      function() {
        return $("#{jquery_query}").size();
      }();
    EOS
  end

  def jquery_have_css(jquery_query)
    result = false
    Timeout.timeout(Capybara.default_wait_time) do
      while !result
        sleep 1
        result = jquery_element_count(jquery_query) > 0
      end
    end
    result
  end

  RSpec::Matchers.define :have_jquery_css do |jquery_query|
    match do
      jquery_have_css(jquery_query)
    end
  end

  RSpec::Matchers.define :have_selected_sense_suggestion_at_index do |suggestion_index|
    match do
      jquery_have_css(".result-suggestions li:nth-child(#{suggestion_index}).selected")
    end
  end
end
