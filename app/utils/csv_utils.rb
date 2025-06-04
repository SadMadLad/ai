class CsvUtils
  class << self
    def parse(csv_file, parse_array, col_sep: ",", has_headers: true)
      csv_data = CSV.parse(File.read(csv_file), col_sep:)
      csv_data = csv_data[1..-1] if has_headers

      csv_data.map do |csv_row|
        csv_row.zip(parse_array).map do |csv_cell, parse_method|
          csv_cell = csv_cell.public_send(parse_method) if parse_method.present?

          csv_cell
        end
      end
    end
  end
end
