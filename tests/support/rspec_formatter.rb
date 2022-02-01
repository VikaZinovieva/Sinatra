require 'rspec/core'

class RspecFormatter
  RSpec::Core::Formatters.register self, :dump_pending, :dump_failures, :close, :examples, :dump_summary, :pending_count,
                                   :failure_count

  def initialize(output)
    @output = output
  end

  def dump_pending(notification)
    @output << examples_output(notification, 'pending')
  end

  def dump_failures(notification)
    @output << examples_output(notification, 'failed')
  end

  def dump_summary(notification)
    @output << "\n\nFinished in #{RSpec::Core::Formatters::Helpers.format_duration(notification.duration)}."
    @output << "\n\nTotal examples #{notification.examples.size}"
    @output << "\n\nFailed examples #{notification.failure_count}"
    @output << "\n\nPending examples #{notification.pending_count}"
    @output << "\n\nPassed examples #{notification.examples.size - notification.failure_count - notification.pending_count}"
  end

  def close(notification)
    @output << "\n"
  end

  private

  def examples_output(notification, example_type)
    unless notification.send("#{example_type}_examples").empty?
      failed_examples_output = notification.send("#{example_type}_examples").map { |example| example_output example }
      build_examples_output(failed_examples_output, example_type)
    end
  end

  def build_examples_output(output, example_type)
    output.join("\n#{example_type}:\n".upcase!)
  end

  def example_output(example)
    full_description = example.full_description
    location = example.location
    formatted_message = strip_message_from_whitespace(example.execution_result.exception.message)
    "#{full_description} - #{location} \n  #{formatted_message}"
  end

  def strip_message_from_whitespace(msg)
    msg.split("\n").map(&:strip).join("\n#{add_spaces(10)}")
  end

  def add_spaces n
    " " * n
  end
end
