module Herbie
  module Helpers
    
    def erb_with_output_buffer(buf = '')
      @_out_buf, old_buffer = buf, @_out_buf
      yield
      @_out_buf
    ensure
      @_out_buf = old_buffer
    end

    def capture_erb(*args, &block)
      erb_with_output_buffer { block_given? && block.call(*args) }
    end

    def erb_concat(text)
      @_out_buf << text if !@_out_buf.nil?
    end
    
  end
end