#####################################################
#Descripcion:  Helper to get the CSV data           #
#####################################################

require 'fileutils'
require 'csv'


#####################################################
# READ CSV DATA
#####################################################

#Method to get the data from a csv in hash map
# @params:
#   :csv_data name of the CSV file to upload
def get_csv_data(csv_data)
  csv_file = nil

  #Get the path and name of the CSV file
  if csv_data.to_s.include? '.csv'
    csv_file =  File.join(File.dirname(__FILE__), "../venture/config/csv_data/#{csv_data}")
  elsif (
    csv_file = File.join(File.dirname(__FILE__), "../venture/config/csv_data/#{csv_data}.csv")
    )
  end

  csv_arr = CSV.read( csv_file,  {:headers => true, :header_converters => :symbol, :encoding => 'UTF-8'} )
  keys = csv_arr.headers.to_a
  # read attribute example => csv[index][:column1]
  return csv_arr.to_a.map {|row| Hash[ keys.zip(row) ] }
end


#####################################################
# WRITE CSV DATA
#####################################################

def exportHashToCsv(data, file)

  csv_file = nil
  #Get the path and name of the CSV file
  if file.to_s.include? '.csv'
    csv_file =  File.join(File.dirname(__FILE__), "../venture/config/csv_data/#{file}")
  elsif (
    csv_file = File.join(File.dirname(__FILE__), "../venture/config/csv_data/#{file}.csv")
  )
  end

  CSV.open(csv_file, "w", headers: data.first.keys) do |csv|
    data.each do |h|
      csv << h.values
    end
  end

end




#####################################################
# FILTER CSV DATA (HASH MAP FILTER)
#####################################################

# Allows you to filter a hash map from csv data
# @params
#   :dt_filters String, filters to apply to the csv data pool. column filters are delimited by ',' (comma)
#       - operators: '=, !=, >, >=, <, <=, contains'
#       - example: 'column1 = value, column2 != value, column3 > value, column4 <= value, column5 contains value'
#   :csv ARRAY HASH MAP, Hash with data of 1 csv
def get_data_by_filters(filters, csv)

  filters_a = filters.to_s.split(',')
  csv_tmp  = Array.new
  csv_tmp = csv

  for i in 0..(filters_a.size - 1)

    filter = filters_a[i].to_s.downcase.strip
    filter_data = get_filter_data filter
    #The array is cleaned
    data_filtered = Array.new

    csv_tmp.each_with_index do |(record), index|

      #Add csv headers
      if index == 0
        #data_filtered.push(record)
      end

      case filter_data[:operador].to_s.strip
        when '='
          if record[filter_data[:key].to_s.to_sym] == filter_data[:value].to_s
            data_filtered.push(record)
          end
        when '!='
          if record[filter_data[:key].to_s.to_sym] != filter_data[:value].to_s
            data_filtered.push(record)
          end
        when '>'
          if record[filter_data[:key].to_s.to_sym].to_s.to_f > filter_data[:value].to_s.to_f
            data_filtered.push(record)
          end
        when '>='
          if record[filter_data[:key].to_s.to_sym].to_s.to_f >= filter_data[:value].to_s.to_f
            data_filtered.push(record)
          end
        when '<'
          if record[filter_data[:key].to_s.to_sym].to_s.to_f < filter_data[:value].to_s.to_f
            data_filtered.push(record)
          end
        when '<='
          if record[filter_data[:key].to_s.to_sym].to_s.to_f <= filter_data[:value].to_s.to_f
            data_filtered.push(record)
          end
        when 'contains'
          if record[filter_data[:key].to_s.to_sym].to_s.downcase.include? filter_data[:value].to_s.downcase
            data_filtered.push(record)
          end
      end

    end

    #The data of the 1st filter is added to 'csv_tmp' to reduce the filtered records
    csv_tmp = data_filtered

  end

  return data_filtered

end


def get_filter_data(filter)

  filter_a = Array.new
  filter_data = Hash.new

  if filter.include? '=' and !filter.include? '!='
    filter_a = filter.split('=')
    operador = '='
  elsif filter.include? '!='
    filter_a = filter.split('!=')
    operador = '!='
  elsif filter.include? '>'
    filter_a = filter.split('>')
    operador = '>'
  elsif filter.include? '>='
    filter_a = filter.split('>=')
    operador = '>='
  elsif filter.include? '<'
    filter_a = filter.split('<')
    operador = '<'
  elsif filter.include? '<='
    filter_a = filter.split('<=')
    operador = '<='
  elsif filter.include? 'contains'
    filter_a = filter.split('contains')
    operador = 'contains'
  end

  filter_data = {:key => filter_a[0].to_s.strip, :value => filter_a[1].to_s.strip, :operador => operador}

end




