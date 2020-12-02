#####################################################
#Autor: Testingit                                   #
#Descripcion:  Helper para obtener los datos del csv#
#####################################################

require 'fileutils'
require 'csv'


#####################################################
# READ CSV DATA
#####################################################

#Metodo obtener la data de un csv en hash map
# @params:
#   :csv_data nobre del archivo csv que se va cargar
def get_csv_data(csv_data)
  csv_file = nil

  #obtiene el path y nombre del archivo csv
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
  #obtiene el path y nombre del archivo csv
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

# Permite filtrar un hash map proveniente de csv data
# @params
#   :dt_filters String, filtros a aplicar al datapool csv. los filtros a columnas se delimitan por ',' (coma)
#       - operadores: '=, !=, >, >=, <, <=, contains'
#       - ejemplo: 'columna1 = valor, columna2 != valor, columna3 > valor, columna4 <= valor, columna5 contains valor'
#   :csv ARRAY HASH MAP, hash con data de 1 csv
def get_data_by_filters(filters, csv)

  filters_a = filters.to_s.split(',')
  csv_tmp  = Array.new
  csv_tmp = csv

  for i in 0..(filters_a.size - 1)

    filter = filters_a[i].to_s.downcase.strip
    filter_data = get_filter_data filter
    #se limipia el array
    data_filtered = Array.new

    csv_tmp.each_with_index do |(record), index|

      #agregar headeres del csv
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

    #Se agregan los datos del 1er filtro a 'csv_tmp' para ir reduciendo los registros filtrados
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




