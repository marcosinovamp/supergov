module JogosHelper
 
    def percent(number)
        @porc = number*100
        @porc = @porc.round(2)
        return "#{(sprintf "%.2f", @porc).gsub(".", ",").gsub(",000", "")}%"
    end

    def nmb_form(number)
        number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse
    end

end
